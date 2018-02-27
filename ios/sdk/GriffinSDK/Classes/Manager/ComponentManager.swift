//
//  ComponentManager.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/1/6.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation
import JavaScriptCore

class ComponentManager: NSObject {
    
    static let instance = ComponentManager()
    
    private let _stopRunning = false
    
    private var _componentThread: Thread?
    private var _uiTaskQueue = [()->Void]()
    private var _displayLink: CADisplayLink?
    private var _noTaskTickCount = 0
    
    func unload() {
        assert(Thread.current == self._componentThread, "unload should be called in _componentThread")
        DispatchQueue.main.sync {
            for rootComponent in RootComponentManager.instance.allRootComponents {
                rootComponent.view.removeFromSuperview()
                rootComponent.removeChildren()
            }
            _uiTaskQueue.removeAll()
        }
    }

    private override init() {
        super.init()
        
        _componentThread = Thread.init(target: self, selector: #selector(self._run), object: nil)
        _componentThread?.name = ComponentThreadName
        _componentThread?.start()
        
        performOnComponentThread {
            startDisplayLink()
        }
    }
    
    @objc private func _handleDisplayLink(){
        assert(Thread.current == self._componentThread, "_handleDisplayLink should be called in _componentThread")
        _layoutAndSyncUI()
    }
    
    @objc private func _run() {
        RunLoop.current.add(Port.init(), forMode: RunLoopMode.defaultRunLoopMode)
        while (!_stopRunning && RunLoop.current.run(mode: .defaultRunLoopMode, before: Date.distantFuture)){}
        
    }
    
    @objc func performOnComponentThread(block: @convention(block)() -> Void ) {
        
        if Thread.current === self._componentThread {
            block()
        } else {
            self.perform(#selector(self.performOnComponentThread(block:)), on: self._componentThread!, with: block, waitUntilDone: false)
        }
    }
    
    private func _addUITask(_ block: @escaping () -> Void) {
        assert(Thread.current == self._componentThread, "_addUITask should be called in _componentThread")
        _uiTaskQueue.append(block)
    }

    
    private func _layoutAndSyncUI() {
        assert(Thread.current == self._componentThread, "_layoutAndSyncUI should be called in _componentThread")
        _layout()
        if(_uiTaskQueue.count > 0){
            _syncUITasks()
            _noTaskTickCount = 0
        } else {
            // suspend display link when there's no task for 1 second, in order to save CPU time.
            _noTaskTickCount += 1
            if (_noTaskTickCount > 60) {
                _suspendDisplayLink()
            }
        }
    }
    
    private func _layout() {
        assert(Thread.current == self._componentThread, "_layout should be called in _componentThread")
        
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
        assert(Thread.current == self._componentThread, "_syncUITasks should be called in _componentThread")
        
        let blocks = _uiTaskQueue
        _uiTaskQueue = [()->Void]()
        
        DispatchQueue.main.async {
            for item in blocks {
                item()
            }
        }
    }
}

extension ComponentManager {
    
    public func startDisplayLink() {
        assert(Thread.current == self._componentThread, "_startDisplayLink should be called in _componentThread")
        
        if self._displayLink != nil {
            return
        }
        _displayLink = CADisplayLink.init(target: self, selector: #selector(self._handleDisplayLink))
        _displayLink?.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
    }
    
    private func _awakeDisplayLink() {
        assert(Thread.current == self._componentThread, "_awakeDisplayLink should be called in _componentThread")
    
        if (_displayLink != nil && _displayLink?.isPaused == true) {
            _displayLink?.isPaused = false
        }
    }

    private func _stopDisplayLink() {
        assert(Thread.current == self._componentThread, "_stopDisplayLink should be called in _componentThread")

        if _displayLink != nil {
            _displayLink?.invalidate()
            _displayLink = nil
        }
    }

    private func _suspendDisplayLink() {
        assert(Thread.current == self._componentThread, "_suspendDisplayLink should be called in _componentThread")

        if (_displayLink != nil && _displayLink?.isPaused == false) {
            _displayLink?.isPaused = true
        }
    }
}

//MARK: - Elements Operations
extension ComponentManager {
    
    func createRootView(_ instanceId:String) -> Void {
        assert(Thread.current == self._componentThread, "createRootView should be called in _componentThread")
        
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
        
        assert(Thread.current == self._componentThread, "createElement should be called in _componentThread")
        
        if let component = _buildComponent(instanceId, withData:componentData) {
            component.rootViewId = rootViewId
            RootComponentManager.instance.addComponent(rootComponentRef: rootViewId, componentRef: instanceId, component: component)
            _awakeDisplayLink()
        }
    }
    
    func removeChildren(rootViewId: String,instanceId: String) {
        
        assert(Thread.current == self._componentThread, "removeChildren should be called in _componentThread")
        
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
        
        assert(Thread.current == self._componentThread, "updateElement should be called in _componentThread")
        
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
        
        assert(Thread.current == self._componentThread, "addElement should be called in _componentThread")
        
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
        
        assert(Thread.current == self._componentThread, "addElement should be called in _componentThread")

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
        
        assert(Thread.current == self._componentThread, "_buildComponent should be called in _componentThread")
        
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
        
        assert(Thread.current == self._componentThread, "register should be called in _componentThread")
        
        Log.Info("register \(instanceId) for \(event), withCallBack: \(callBack)")
        
        guard let component = RootComponentManager.instance.getComponent(rootComponentRef: rootViewId, componentRef: instanceId) else {
            Log.Error("register failed! Cannot find instance \(instanceId)")
            return
        }
        
        component.register(event: event, callBack: callBack)
    }
    
    func unRegister(event: String, rootViewId:String, instanceId:String, callBack: JSValue){
        
        assert(Thread.current == self._componentThread, "unRegister should be called in _componentThread")
        
        Log.Info("unRegister \(instanceId) for \(event), withCallBack: \(callBack)")
        
        guard let component = RootComponentManager.instance.getComponent(rootComponentRef: rootViewId, componentRef: instanceId)  else {
            Log.Error("unRegister failed! Cannot find instance \(instanceId)")
            return
        }
        component.unRegister(event: event, callBack: callBack)
    }
}

