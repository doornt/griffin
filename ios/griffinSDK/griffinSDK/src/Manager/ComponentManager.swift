//
//  ComponentManager.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/1/6.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class ComponentManager: NSObject {
    
    static let instance = ComponentManager()
    
    
    private var _indexDict = [String: ViewComponent]()
    private let _stopRunning = false
    
    private var _componentThread: Thread?
    private var _uiTaskQueue = [()->Void]()
    private var _displayLink: CADisplayLink?
    
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
    
    func createRootView(_ instanceId:String) -> Void {
        let component = DivView.init(ref: instanceId, styles: ["background-color":"#FF0000",
                                                               "height":Environment.instance.screenHeight,
                                                               "width":Environment.instance.screenWidth,
                                                               "top":0,
                                                               "left":0])
        _indexDict[instanceId] = component
        
        _addUITask {
            RenderManager.instance._rootController?.setRootView(component.view)
        }
    }
    
    func createElement(_ instanceId: String, withData componentData:[String: Any]) {
        let _ = _buildComponent(instanceId, withData:componentData)
    }
    
    func addElement(_ parentId:String, childId: String){
        guard let superComponent = _indexDict[parentId],
              let childComponent = _indexDict[childId] else {
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
        _indexDict[instanceId] = viewComponent
        return viewComponent
    }
    
    
    func _addUITask(_ block: @escaping () -> Void) {
        _uiTaskQueue.append(block)
    }
}
