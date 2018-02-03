//
//  JSCore.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/20.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import Foundation
import JavaScriptCore

extension JSValue {
    func callWithoutArguments() {
        JSCoreBridge.instance.callWith(obj: self)
    }
    func callWithArguments(_ arguments: Any?) {
        JSCoreBridge.instance.callWith(obj: self, agruments: arguments)
    }
}

extension JSCoreBridge {
    
    func dispatchEventToJs(rootviewId instanceId: String, data: [String: Any?]) {
        callJs(method: "dispatchEventToJs", args: [instanceId, data])
    }
    
    func executeJavascript(script:String) {
        if Thread.current === self._thread {
            self._jsContext.evaluateScript(script)
            self.loaded = true
            
            for o in self._methodQueue{
                let obj = o as! Dictionary<String,Any>
                self.callJs(method: obj["method"] as! String, args: obj["args"] as! Array<Any>)
            }
        } else {
            self._jsContext.perform(#selector(self._jsContext.evaluateScript(_:)), on: self._thread!, with: script, waitUntilDone: false)
        }
    }
    
    func callJs(method:String,args:Array<Any>){
        if Thread.current == self._thread {
            if self.loaded{
                self._callJsMethod(dict: ["method" :method, "args": args])
            }else{
                self._methodQueue.append(["method":method,"args":args])
            }
        } else {
            perform(#selector(self._callJsMethod), on: self._thread!, with: ["method" :method, "args": args], waitUntilDone: false)
        }
    }
    
    @objc private func _callJsMethod(dict:[String: Any]){
        self._jsContext.globalObject.invokeMethod(Utils.any2String(dict["method"]), withArguments: dict["args"] as! [Any])
    }
    
    @objc func performOnJSThread(block: @convention(block)() -> Void ) {
        
        if Thread.current === self._thread {
            block()
        } else {
            self.perform(#selector(self.performOnJSThread(block:)), on: self._thread!, with: block, waitUntilDone: false)
        }
    }
    
    
    func getContext()->JSContext{
        return self._jsContext
    }
    
    func registerHanler(){
        //        _jsContext.
    }
    
    func register<T>(method:T,script:String){
        _jsContext.setObject(unsafeBitCast(method,to: AnyObject.self) , forKeyedSubscript: script as NSCopying & NSObjectProtocol)
    }
    
    func callWith(obj: JSValue) {
        obj.perform(#selector(obj.call), on: self._thread!, with: [], waitUntilDone: false)
    }
    func callWith(obj: JSValue, agruments: Any?) {
        obj.perform(#selector(obj.call), on: self._thread!, with: [agruments], waitUntilDone: false)
    }
    
    func registerClass<T>(cls:T,name:String){
        self.callJs(method: "registerModule", args: [cls,name])
    }
}

class JSCoreBridge: NSObject {
    
    static let instance:JSCoreBridge = {
        return JSCoreBridge()
    }()
    
    private let _jsContext:JSContext = JSContext(virtualMachine: JSVirtualMachine())
    private var _thread: Thread?
    
    private var loaded = false

    private let _stopRunning = false
    
    private var _methodQueue:[Any] = []
    
    private override init() {
        
        super.init()
        
        self._jsContext.name = "Griffin Context"
        
        self.initEnvironment()
        self.initJsFunctions()

        _thread = Thread.init(target: self, selector: #selector(self.run), object: nil)
        _thread?.name = JSBridgeThreadName
        _thread?.start()
    }
    
    @objc private func run() {
        RunLoop.current.add(Port.init(), forMode: RunLoopMode.defaultRunLoopMode)
        while (!_stopRunning && RunLoop.current.run(mode: .defaultRunLoopMode, before: Date.distantFuture)){}

    }
    
    private func initEnvironment(){
        _jsContext.setObject(Environment.instance.get(), forKeyedSubscript: "Environment" as NSCopying & NSObjectProtocol)
    }
    
    private func initJsFunctions(){
        let timeoutFunc:@convention(block)(JSValue,Int) ->Void = {
            (cb,wait) in
            DispatchQueue.main.asyncAfter(deadline:DispatchTime(uptimeNanoseconds:UInt64(wait) * NSEC_PER_MSEC)){
                (cb as JSValue).call(withArguments: [])
            }
        }
        _jsContext.setObject(unsafeBitCast(timeoutFunc, to: AnyObject.self), forKeyedSubscript: "setTimeout" as NSCopying & NSObjectProtocol)
    
        let logDict = ["__LOG":true,"__WARN":true]
        let consoleLog:@convention(block)()-> Void = {
            var message:String = ""
            var key:String = ""
            if let args = JSContext.currentArguments(){
                for (index,arg) in args.enumerated(){
                    if index == args.count - 1 && logDict["\(arg)"] != nil{
                        key = "\(arg)"
                    }else{
                        message = message + "\(arg)\t"
                    }
                }
            }
            print("JS\(key):\(message)\n")
        }
        _jsContext.setObject(unsafeBitCast(consoleLog, to: AnyObject.self),forKeyedSubscript: "NativeLog" as NSCopying & NSObjectProtocol)
        
        _jsContext.exceptionHandler = {(ctx: JSContext!, value: JSValue!) in
            let stacktrace = value.objectForKeyedSubscript("stack").toString()
            let lineNumber = value.objectForKeyedSubscript("line")
            let column = value.objectForKeyedSubscript("column")
            let moreInfo = "in method \(String(describing: stacktrace))Line number in file: \(String(describing: lineNumber)), column: \(String(describing: column))"
            
            print("\nJS ERROR: \(value) \(moreInfo)")
        }
                
    }
}
