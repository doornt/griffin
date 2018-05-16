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
        _jsBridge.register(method: { self.onRuntimeLoadFinish() } as @convention(block)()-> Void, script: "onRuntimeLoadFinish")
    }
    
    private func onRuntimeLoadFinish(){
        _loaded = true
        for o in self._methodQueue {
            let obj = o as! Dictionary<String,Any>
            self.callJs(method: obj["method"] as! String, args: obj["args"] as! Array<Any>)
        }
        callJs(method: "runtimeLoadedResponse", args: [])
    }
}
