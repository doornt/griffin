//
//  ComponentManager.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/1/6.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation
import JavaScriptCore

class ComponentManager {
    
    static let instance = ComponentManager()
    
    private var _uiTaskQueue = [()->Void]()
    private var _displayLink: CADisplayLink?
    private var _noTaskTickCount = 0
    
    func unload() {
        DispatchQueue.main.sync {
            for rootComponent in RootComponentManager.instance.allRootComponents {
                rootComponent.view.removeFromSuperview()
                rootComponent.removeChildren()
            }
            _uiTaskQueue.removeAll()
        }
    }

    init() {
        startDisplayLink()
    }
    
    @objc private func _handleDisplayLink(){
        _layoutAndSyncUI()
    }
    
    private func _addUITask(_ block: @escaping () -> Void) {
        _uiTaskQueue.append(block)
    }

    private func _layoutAndSyncUI() {
        _layout()
        if(_uiTaskQueue.count > 0){
            _syncUITasks()
            _noTaskTickCount = 0
        } else {
            _noTaskTickCount += 1
            if (_noTaskTickCount > 60) {
                _suspendDisplayLink()
            }
        }
    }
    
    private func _layout() {
        
        let components = RootComponentManager.instance.addedComponents
        
        var needsLayout = false
        for o in components {
            if o.needsLayout {
                needsLayout = true
                break
            }
        }
        
        if (!needsLayout) {
            return
        }
        
        guard let root = RootComponentManager.instance.topRootComponent else {
            return
        }

        root.applyLayout()
        
        _addUITask {
            for o in components {
                o.layoutFinish()
            }
        }
    }
    
    private func _syncUITasks() {
        
        let blocks = _uiTaskQueue
        _uiTaskQueue = [()->Void]()
        
        DispatchQueue.main.async {
            for item in blocks {
                item()
            }
        }
    }
}

//MARK: - Elements Operations
extension ComponentManager {
    
    func createRootView(_ instanceId:String) -> Void {
        
        let component = DivView.init(ref: instanceId, styles: ["background-color":"#FFFFFF",
                                                               "height":Environment.instance.screenHeight,
                                                               "width":Environment.instance.screenWidth,
                                                               "top":0,
                                                               "left":0],props: [:])
        component.rootViewId = instanceId

        RootComponentManager.instance.pushRootComponent(component)

        _awakeDisplayLink()
    }
    
    func createElement(rootViewId: String, instanceId: String, withData componentData:[String: Any]) {
     
        if let component = _buildComponent(instanceId, withData:componentData) {
            component.rootViewId = rootViewId
            RootComponentManager.instance.addComponent(rootComponentRef: rootViewId, componentRef: instanceId, component: component)
            _awakeDisplayLink()
        }
    }
    
    func removeChildren(rootViewId: String,instanceId: String) {
        
        guard let component = RootComponentManager.instance.getComponent(rootComponentRef: rootViewId, componentRef: instanceId) else {
            Log.Error("remove children while canmpy get child \(instanceId) in rootview \(rootViewId)")
            return
        }
        _addUITask {
            component.removeChildren()
        }
        
        _awakeDisplayLink()
    }
    
    func updateElement(rootViewId: String, instanceId:String, data: Dictionary<String,Any>) {
        
        guard let component = RootComponentManager.instance.getComponent(rootComponentRef: rootViewId, componentRef: instanceId) else {
            Log.Error("updateElement while cannot get child \(instanceId) in rootview \(rootViewId)")
            return
        }
        // 目前 updateWithStyle 没有触发layout
        component.updateWithStyle(data["styles"] as![String:Any])
        _addUITask {
            component.refresh()
        }
        _awakeDisplayLink()
    }
    
    func addElement(rootViewId: String, parentId:String, childId: String){
        
        guard let superComponent = RootComponentManager.instance.getComponent(rootComponentRef: rootViewId, componentRef: parentId),
            let childComponent = RootComponentManager.instance.getComponent(rootComponentRef: rootViewId, componentRef: childId) else {
                
                Log.Error("addElement while cannot get child \(childId) or parent \(parentId) in rootview \(rootViewId)")
                return
        }
        _addUITask {
            superComponent.addChild(childComponent)
        }
        _awakeDisplayLink()
    }
    
    func addElements(rootViewId: String, parentId:String, childIds: [String]){
        
        guard let superComponent = RootComponentManager.instance.getComponent(rootComponentRef: rootViewId, componentRef: parentId) else {
                Log.Error("addElements while cannot parent \(parentId) in rootview \(rootViewId)")
                return
        }
        let childrenComponents = childIds.map { (childId) -> ViewComponent? in
            return RootComponentManager.instance.getComponent(rootComponentRef: rootViewId, componentRef: childId)
        }


        _addUITask {
            superComponent.addChildren(childrenComponents)
        }
        _awakeDisplayLink()
    }
    
    private func _buildComponent(_ instanceId: String, withData data:[String: Any]) -> ViewComponent? {
        
        guard let type = Utils.any2String(data["type"]) else {
            Log.Error("type cannot be nil")
            return nil
        }
        
        guard let typeClass = ComponentFactory.instance.component(withTag:type) as? ViewComponent.Type else {
            Log.Error("cannot get class for \(type)")
            return nil
        }
        
        let viewComponent: ViewComponent =  typeClass.init(ref: instanceId, styles: data["styles"] as![String:Any],props:data["props"] as! [String:Any])
        return viewComponent
    }
}

extension ComponentManager {
    
    func register(event:String, rootViewId:String, instanceId:String,  callBack: JSValue){
        
        Log.Info("register \(instanceId) for \(event), withCallBack: \(callBack)")
        
        guard let component = RootComponentManager.instance.getComponent(rootComponentRef: rootViewId, componentRef: instanceId) else {
            Log.Error("register failed! Cannot find instance \(instanceId)")
            return
        }
        
        component.register(event: event, callBack: callBack)
    }
    
    func unRegister(event: String, rootViewId:String, instanceId:String, callBack: JSValue){
        
        Log.Info("unRegister \(instanceId) for \(event), withCallBack: \(callBack)")
        
        guard let component = RootComponentManager.instance.getComponent(rootComponentRef: rootViewId, componentRef: instanceId)  else {
            Log.Error("unRegister failed! Cannot find instance \(instanceId)")
            return
        }
        component.unRegister(event: event, callBack: callBack)
    }
}

extension ComponentManager {
    
    public func startDisplayLink() {
        
        if self._displayLink != nil {
            return
        }
        _displayLink = CADisplayLink.init(target: self, selector: #selector(self._handleDisplayLink))
        _displayLink?.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
    }
    
    private func _awakeDisplayLink() {
        if (_displayLink != nil && _displayLink?.isPaused == true) {
            _displayLink?.isPaused = false
        }
    }
    
    private func _stopDisplayLink() {
        if _displayLink != nil {
            _displayLink?.invalidate()
            _displayLink = nil
        }
    }
    
    private func _suspendDisplayLink() {
        if (_displayLink != nil && _displayLink?.isPaused == false) {
            _displayLink?.isPaused = true
        }
    }
}
