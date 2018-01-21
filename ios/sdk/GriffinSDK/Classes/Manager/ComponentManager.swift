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
    private var _noTaskTickCount = 0
    
    private var _rootController:BaseViewController?
    
    private var _rootComponent:ViewComponent?
    
    func setRootController(root:BaseViewController){
        Log.LogInfo("Init RootController \(root)")
        self._rootController = root
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
        
        var needsLayout = false
        for (_, o) in _components {
            if o.needsLayout {
                needsLayout = true
                break
            }
        }
        
        if (!needsLayout) {
            return
        }
        
        guard let root = self._rootComponent else {
            return
        }
        
//        _addUITask {
        root.applyLayout()
//        }
        
        
        for (_,o) in _components {
            _addUITask {
                o.layoutFinish()
            }
        }
        
//        layoutNode(_rootCSSNode, _rootCSSNode->style.dimensions[CSS_WIDTH], _rootCSSNode->style.dimensions[CSS_HEIGHT], CSS_DIRECTION_INHERIT);
//
//        if ([_rootComponent needsLayout]) {
//            if ([WXLog logLevel] >= WXLogLevelDebug) {
//                print_css_node(_rootCSSNode, CSS_PRINT_LAYOUT | CSS_PRINT_STYLE | CSS_PRINT_CHILDREN);
//            }
//        }
        
//        NSMutableSet<WXComponent *> *dirtyComponents = [NSMutableSet set];
//        [_rootComponent _calculateFrameWithSuperAbsolutePosition:CGPointZero gatherDirtyComponents:dirtyComponents];
//        [self _calculateRootFrame];
//
//        for (WXComponent *dirtyComponent in dirtyComponents) {
//            [self _addUITask:^{
//                [dirtyComponent _layoutDidFinish];
//                }];
//        }
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
        
        let component = DivView.init(ref: instanceId, styles: ["background-color":"#FF0000",
                                                               "height":Environment.instance.screenHeight,
                                                               "width":Environment.instance.screenWidth,
                                                               "top":0,
                                                               "left":0])
        _components[instanceId] = component
        self._rootComponent = component
        _addUITask {
            self._rootController?.setRootView(component.view)
        }
    }
    
    func createElement(_ instanceId: String, withData componentData:[String: Any]) {
        
        assert(Thread.current == self._componentThread, "createElement should be called in _componentThread")
        
        Log.LogInfo("instanceID:\(instanceId) data: \(componentData)")
        let _ = _buildComponent(instanceId, withData:componentData)
    }
    
    func updateElement(_ instanceId:String, data: Dictionary<String,Any>) {
        
        assert(Thread.current == self._componentThread, "updateElement should be called in _componentThread")
        
        guard let component = _components[instanceId] else {
            return
        }
        component.updateWithStyle(data["styles"] as![String:Any])
        _addUITask {
            component.refresh()
        }
    }
    
    func addElement(_ parentId:String, childId: String){
        
        assert(Thread.current == self._componentThread, "addElement should be called in _componentThread")
        
        guard let superComponent = _components[parentId],
            let childComponent = _components[childId] else {
                return
        }
        _addUITask {
            superComponent.addChild(childComponent)
        }
        
    }
    
    private func _buildComponent(_ instanceId: String, withData data:[String: Any]) -> ViewComponent? {
        
        assert(Thread.current == self._componentThread, "_buildComponent should be called in _componentThread")
        
        guard let type = Utils.any2String(data["type"]) else {
            Log.LogError("type cannot be nil")
            return nil
        }
        
        guard let typeClass = ComponentFactory.instance.component(withTag:type) as? ViewComponent.Type else {
            Log.LogError("cannot get class for \(type)")
            return nil
        }
        
        let viewComponent: ViewComponent =  typeClass.init(ref: instanceId, styles: data["styles"] as![String:Any])
        _components[instanceId] = viewComponent
        return viewComponent
    }
}

extension ComponentManager {
    
    func register(event:String, instanceId:String,  callBack: JSValue){
        
        assert(Thread.current == self._componentThread, "register should be called in _componentThread")
        
        Log.LogInfo("register \(instanceId) for \(event), withCallBack: \(callBack)")
        
        guard let component = _components[instanceId] else {
            Log.LogError("register failed! Cannot find instance \(instanceId)")
            return
        }
        
        component.register(event: event, callBack: callBack)
    }
    
    func unRegister(event: String, instanceId:String, callBack: JSValue){
        
        assert(Thread.current == self._componentThread, "unRegister should be called in _componentThread")
        
        Log.LogInfo("unRegister \(instanceId) for \(event), withCallBack: \(callBack)")
        
        guard let component = _components[instanceId] else {
            Log.LogError("unRegister failed! Cannot find instance \(instanceId)")
            return
        }
        component.unRegister(event: event, callBack: callBack)
    }
}

