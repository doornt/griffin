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
        call(withArguments: [])
    }
    
    func callWithDictionary(_ arguments: Dictionary<String, Any>?) {
        call(withArguments: arguments != nil ? [arguments!] : [])
    }
    
    func callWithAny(_ arguments: Any?) {
        let arg = arguments != nil ? [arguments!] : []
        call(withArguments: arg)
    }
}

extension JSBridgeContext {
    
    func executeJavascript(script:String) {
        let _ = _jsBridge.executeJavascript(script: script)
    }
    
    func executeJavascript(script:String, withSourceUrl url:URL) {
        let _ = _jsBridge.executeJavascript(script: script, withSourceUrl: url)
    }
    
    func register<T>(method:T,script:String){
        _jsBridge.register(method: method, script: script)
    }
    
    func registerComponent2JS(_ component: String) {
        callJs(method: "registerNativeComponent", args: [component])
    }
    
    func dispatchEventToJs(rootviewId instanceId: String, data: [String: Any?]) {
        callJs(method: "dispatchEventToJs", args: [instanceId, data])
    }
    
    func callJs(method:String,args:Array<Any>){
        if _loaded {
            let _ = _jsBridge.callJsMethod(dict: ["method" :method, "args": args])
        }else{
            self._methodQueue.append(["method":method,"args":args])
        }
    }
}

class JSBridgeContext {
    
    static let instance:JSBridgeContext = {
        return JSBridgeContext()
    }()
    
    private lazy var _jsBridge: JSCoreBridge = {
        let jsBridge = JSCoreBridge()
        return jsBridge
    }()
    
    private var _loaded = false
    
    private var _methodQueue:[Any] = []
    
    init() {
        initGlobalFunctions()
    }
    
    // MARK: - Component
    private let _createRootView:@convention(block)(String)-> Void = {
        obj in
        GnDispatchCenter.instance.createRootView(obj)
    }
    
    private let _createElementBlock:@convention(block)(String, String, Dictionary<String,Any>) -> Void = {
        rootViewId, instanceId, obj in
        GnDispatchCenter.instance.createElement(rootViewId: rootViewId, instanceId: instanceId, withData: obj)
    }
    
    private let _removeChildrenBlock:@convention(block)(String,String) -> Void = {
        rootViewId,instanceId in
        GnDispatchCenter.instance.removeChildren(rootViewId: rootViewId, instanceId: instanceId)
    }
    
    private let _addSubview:@convention(block)(String, String, String)-> Void = {
        rootViewId, parentId, childId in
        GnDispatchCenter.instance.addElement(rootViewId: rootViewId, parentId: parentId, childId: childId)
    }
    
    private let _addViews:@convention(block)(String, String, [String])-> Void = {
        rootViewId, parentId, childIds in
        GnDispatchCenter.instance.addElements(rootViewId: rootViewId, parentId: parentId, childIds: childIds)
    }
    
    private let _updateElement:@convention(block)(String, String, Dictionary<String,Any>)-> Void = {
        rootViewId, instanceId, data in
        GnDispatchCenter.instance.updateElement(rootViewId: rootViewId, instanceId: instanceId, data: data)
    }
    
    // MARK: - Event
    private let _registerEvent:@convention(block)(String, String, String, JSValue)-> Void = {
        rootViewId, instanceId, event, callBack in
        GnDispatchCenter.instance.register(event: event, rootViewId: rootViewId, instanceId: instanceId, callBack: callBack)
    }
    
    private let _unRegisterEvent:@convention(block)(String, String, String, JSValue)-> Void = {
        rootViewId, instanceId, event, callBack in
        GnDispatchCenter.instance.unRegister(event: event, rootViewId: rootViewId, instanceId: instanceId, callBack: callBack)
    }
    
    // MARK: - Network
    private let _fetch:@convention(block)(String, [String: String], JSValue)-> Void = {
        url, params, callback in
        GnDispatchCenter.instance.fetch(url, params:params, callback:callback)
    }
}


extension JSBridgeContext {
    private func onRuntimeLoadFinish(){
        _loaded = true
        for o in self._methodQueue {
            let obj = o as! Dictionary<String,Any>
            self.callJs(method: obj["method"] as! String, args: obj["args"] as! Array<Any>)
        }
        callJs(method: "runtimeLoadedResponse", args: [])
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
        
        // MARK: WebSocket
        _jsBridge.register(method: {
            url in
            return WebSocket.init(url)
            } as @convention(block) (String) -> WebSocket, script: "WebSocket")
        
        // MARK: Navigator
        _jsBridge.register(method: { return Navigator.init() } as @convention(block) () -> Navigator, script: "Navigator")
    }
}
