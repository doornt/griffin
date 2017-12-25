//
//  JSCore.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/20.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import Foundation

import JavaScriptCore


public class JSCoreBridge {
    
    public static let instance:JSCoreBridge = {
        return JSCoreBridge()
    }()
    
    let _jsContext:JSContext
    
    private init() {
        let jsVirtualMachine = JSVirtualMachine()
        self._jsContext = JSContext(virtualMachine: jsVirtualMachine)
        self._jsContext.name = "Griffin Context"
        
        self.initJsFunctions()

    }
    
    private func initJsFunctions(){
        let timeoutFunc:@convention(block)(JSValue,Int) ->Void = {
            (cb,wait) in
            DispatchQueue.main.asyncAfter(deadline:DispatchTime(uptimeNanoseconds:UInt64(wait) * NSEC_PER_MSEC)){
                (cb as JSValue).call(withArguments: [])
            }
        }
        
        _jsContext.setObject(unsafeBitCast(timeoutFunc, to: AnyObject.self), forKeyedSubscript: "setTimeout" as NSCopying & NSObjectProtocol)
    
        let consoleLog:@convention(block)(String)-> Void = {
            str in
            print(str)
        }
        _jsContext.setObject(unsafeBitCast(consoleLog, to: AnyObject.self),forKeyedSubscript: "consoleLog" as NSCopying & NSObjectProtocol)
    }
    
    public func executeJavascript(script:String){
        _jsContext.evaluateScript(script)
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
    
    
    
}
