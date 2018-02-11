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
    
    func dispatchEventToJs(rootviewId instanceId: String, data: [String: Any?]) {
        performOnJSThread {
            callJs(method: "dispatchEventToJs", args: [instanceId, data])
        }
    }
    
    private func onRuntimeLoadFinish(){
        _loaded = true
        for o in self._methodQueue{
            let obj = o as! Dictionary<String,Any>
            self.callJs(method: obj["method"] as! String, args: obj["args"] as! Array<Any>)
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
    
    
    private func initGlobalFunctions(){
        _jsBridge.register(method: { self.onRuntimeLoadFinish() } as @convention(block)()-> Void, script: "onRuntimeLoadFinish")
    }
}
