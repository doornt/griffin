//
//  JSBridgeContext.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/20.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import Foundation
import JavaScriptCore

extension JSValue {
    func callWithoutArguments() {
        JSBridgeContext.instance.performOnJSThread {
            call(withArguments: [])
        }
    }
    
    func callWithArguments(_ arguments: Any?) {
        JSBridgeContext.instance.performOnJSThread {
            let arg = arguments != nil ? [arguments!] : []
            call(withArguments: arg)
        }
    }
}

extension JSBridgeContext {
    
    func executeJavascript(script:String) {
        performOnJSThread {
            let _ = _jsBridge.executeJavascript(script: script)
        }
    }
    
    func executeJavascript(script:String, withSourceUrl url:URL) {
        performOnJSThread {
            let _ = _jsBridge.executeJavascript(script: script, withSourceUrl: url)
        }
    }
    
    func register<T>(method:T,script:String){
        performOnJSThread {
            _jsBridge.register(method: method, script: script)
        }
    }
    
    func registerComponent2JS(_ component: String) {
        performOnJSThread {
            callJs(method: "registerNativeComponent", args: [component])
        }
    }
    
    func dispatchEventToJs(rootviewId instanceId: String, data: [String: Any?]) {
        performOnJSThread {
            callJs(method: "dispatchEventToJs", args: [instanceId, data])
        }
    }
    
    func callJs(method:String,args:Array<Any>){
        performOnJSThread {
            if _loaded{
                let _ = _jsBridge.callJsMethod(dict: ["method" :method, "args": args])
            }else{
                self._methodQueue.append(["method":method,"args":args])
            }
        }
    }
    
    @objc func performOnJSThread(block: @convention(block)() -> Void ) {
        if Thread.current === self._thread {
            block()
        } else {
            self.perform(#selector(self.performOnJSThread(block:)), on: self._thread!, with: block, waitUntilDone: false)
        }
    }
}

class JSBridgeContext: NSObject {
    
    static let instance:JSBridgeContext = {
        return JSBridgeContext()
    }()
    
    private lazy var _jsBridge: JSCoreBridge = {
        let jsBridge = JSCoreBridge()
        return jsBridge
    }()
    
    private var _thread: Thread?
    
    private var _loaded = false

    private let _stopRunning = false
    
    private var _methodQueue:[Any] = []
    
    private override init() {
        
        super.init()

        _thread = Thread.init(target: self, selector: #selector(self.run), object: nil)
        _thread?.name = JSBridgeThreadName
        _thread?.start()
        
        performOnJSThread {
            initGlobalFunctions()
        }
    }
    
    @objc private func run() {
        RunLoop.current.add(Port.init(), forMode: RunLoopMode.defaultRunLoopMode)
        while (!_stopRunning && RunLoop.current.run(mode: .defaultRunLoopMode, before: Date.distantFuture)){}
    }
    
    // MARK: - Component
    private let _createRootView:@convention(block)(String)-> Void = {
        obj in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.createRootView(obj)
        }
    }
    
    private let _createElementBlock:@convention(block)(String, String, Dictionary<String,Any>) -> Void = {
        rootViewId, instanceId, obj in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.createElement(rootViewId: rootViewId, instanceId: instanceId, withData: obj)
        }
    }
    
    private let _removeChildrenBlock:@convention(block)(String,String) -> Void = {
        rootViewId,instanceId in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.removeChildren(rootViewId: rootViewId,instanceId: instanceId)
        }
    }
    
    private let _addSubview:@convention(block)(String, String, String)-> Void = {
        rootViewId, parentId, childId in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.addElement(rootViewId: rootViewId, parentId: parentId, childId: childId)
        }
    }
    
    private let _addViews:@convention(block)(String, String, [String])-> Void = {
        rootViewId, parentId, childIds in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.addElements(rootViewId: rootViewId, parentId: parentId, childIds: childIds)
        }
    }
    
    private let _updateElement:@convention(block)(String, String, Dictionary<String,Any>)-> Void = {
        rootViewId, instanceId, data in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.updateElement(rootViewId: rootViewId, instanceId: instanceId, data: data)
        }
    }
    
    // MARK: - Event
    private let _registerEvent:@convention(block)(String, String, String, JSValue)-> Void = {
        rootViewId, instanceId, event, callBack in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.register(event: event, rootViewId: rootViewId, instanceId: instanceId, callBack: callBack)
        }
    }
    
    private let _unRegisterEvent:@convention(block)(String, String, String, JSValue)-> Void = {
        rootViewId, instanceId, event, callBack in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.unRegister(event: event, rootViewId: rootViewId, instanceId: instanceId, callBack: callBack)
        }
    }
    
    // MARK: - Network
    private let _fetch:@convention(block)(String, [String: String], JSValue)-> Void = {
        url, params, callback in
        DispatchQueue.main.async {
            NetworkManager.instance.get(url: url, params: params) {
                (data, error) in
                callback.callWithArguments(data)
            }
        }
    }
}


extension JSBridgeContext {
    private func onRuntimeLoadFinish(){
        _loaded = true
        for o in self._methodQueue{
            let obj = o as! Dictionary<String,Any>
            self.callJs(method: obj["method"] as! String, args: obj["args"] as! Array<Any>)
        }
    }
    
    private func initGlobalFunctions(){
        _jsBridge.register(method: { self.onRuntimeLoadFinish() } as @convention(block)()-> Void, script: "onRuntimeLoadFinish")
        
        // MARK: Create View
        _jsBridge.register(method: _createRootView, script: "createRootView")
        _jsBridge.register(method: _createElementBlock, script: "createElement")
        _jsBridge.register(method: _removeChildrenBlock, script: "removeChildren")
        
        // MARK: Operate View
        _jsBridge.register(method: _addSubview, script: "addSubview")
        _jsBridge.register(method: _addViews, script: "addViews")
        _jsBridge.register(method: _updateElement, script: "updateView")
        
        // MARK: Event
        _jsBridge.register(method: _registerEvent, script: "registerEvent")
        _jsBridge.register(method: _unRegisterEvent, script: "unRegisterEvent")
        
        // MARK: Network
        _jsBridge.register(method: _fetch, script: "nativeFetch")
    }
}
