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
    
    private var _components = [String: ViewComponent]()
    private let _stopRunning = false
    
    private var _componentThread: Thread?
    private var _uiTaskQueue = [()->Void]()
    private var _displayLink: CADisplayLink?
    
    private var _rootController:BaseViewController?
    
    func setRootController(root:BaseViewController){
        Log.InfoLog("Init RootController \(root)")
        self._rootController = root
    }
    
    private override init() {
        super.init()
        
        _componentThread = Thread.init(target: self, selector: #selector(self._run), object: nil)
        _componentThread?.name = ComponentThreadName
        _componentThread?.start()
        
        _displayLink = CADisplayLink.init(target: self, selector: #selector(self._handleDisplayLink))
        _displayLink?.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
    }
    
    @objc private func _handleDisplayLink(){
        let blocks = _uiTaskQueue
        _uiTaskQueue = [()->Void]()
        
        DispatchQueue.main.async {
            for item in blocks {
                item()
            }
        }
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
    
    func _addUITask(_ block: @escaping () -> Void) {
        _uiTaskQueue.append(block)
    }
}

//MARK: - Elements Operations
extension ComponentManager {
    
    func createRootView(_ instanceId:String) -> Void {
        let component = DivView.init(ref: instanceId, styles: ["background-color":"#FFFFFF",
                                                               "height":Environment.instance.screenHeight,
                                                               "width":Environment.instance.screenWidth,
                                                               "top":0,
                                                               "left":0])
        _components[instanceId] = component
        
        _addUITask {
            self._rootController?.setRootView(component.view)
        }
    }
    
    func createElement(_ instanceId: String, withData componentData:[String: Any]) {
        let _ = _buildComponent(instanceId, withData:componentData)
    }
    
    func updateElement(_ instanceId:String, data: Dictionary<String,Any>) {
        guard let component = _components[instanceId] else {
            return
        }
        component.updateWithStyle(data["styles"] as![String:Any])
        _addUITask {
            component.refresh()
        }
    }
    
    func addElement(_ parentId:String, childId: String){
        guard let superComponent = _components[parentId],
            let childComponent = _components[childId] else {
                return
        }
        _addUITask {
            superComponent.addChild(childComponent)
        }
    }
    
    func _buildComponent(_ instanceId: String, withData data:[String: Any]) -> ViewComponent? {
        
        guard let type = Utils.any2String(data["type"]) else {
            return nil
        }
        
        guard let typeClass = ComponentFactory.instance.component(withTag:type) as? ViewComponent.Type else {
            return nil
        }
        
        let viewComponent: ViewComponent =  typeClass.init(ref: instanceId, styles: data["styles"] as![String:Any])
        _components[instanceId] = viewComponent
        return viewComponent
    }
}

extension ComponentManager {
    func register(event:String, instanceId:String,  callBack: JSValue){
        Log.InfoLog("register \(instanceId) for \(event), withCallBack: \(callBack)")
        
        guard let component = _components[instanceId] else {
            return
        }
        
        component.register(event: event, callBack: callBack)
    }
    
    func unRegister(event: String, instanceId:String, callBack: JSValue){
        Log.InfoLog("unRegister \(instanceId) for \(event), withCallBack: \(callBack)")
        
        guard let component = _components[instanceId] else {
            return
        }
        
        component.unRegister(event: event, callBack: callBack)
    }
}

