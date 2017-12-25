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
        call(withArguments: [])
    }
}

public class JSCoreBridge {
    
    public static let instance:JSCoreBridge = {
        return JSCoreBridge()
    }()
    
    let _jsContext:JSContext
    
    private init() {
        let jsVirtualMachine = JSVirtualMachine()
        self._jsContext = JSContext(virtualMachine: jsVirtualMachine)
        self._jsContext.name = "Griffin Context"
        
        self.initEnvironment()
        self.initJsFunctions()

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
    
    public func executeAnonymousJSFunction(script:String) {
        _jsContext.evaluateScript(script).call(withArguments: [])
    }
   
    public func executeJavascript(script:String) -> JSValue!{
        return _jsContext.evaluateScript(script)
    }
    
    public func callJsMethod(method:String,args:Array<Any>){
        _jsContext.globalObject.invokeMethod(method, withArguments: args)
    }
    
    public func getContext()->JSContext{
        return self._jsContext
    }
    
    public func registerHanler(){
//        _jsContext.
    }
    
    public func registerCallMethod<T>(method:T,script:String){
        _jsContext.setObject(unsafeBitCast(method,to: AnyObject.self) , forKeyedSubscript: script as NSCopying & NSObjectProtocol)
    }
    
}
