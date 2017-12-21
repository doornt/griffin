//
//  JSCore.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/20.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import Foundation

import JavaScriptCore


public class JSCoreBridge: NSObject {
    
    public static let instance:JSCoreBridge = {
        return JSCoreBridge()
    }()
    
    let _jsContext:JSContext
    
    private override init() {
        let jsVirtualMachine = JSVirtualMachine()
        self._jsContext = JSContext(virtualMachine: jsVirtualMachine)
        self._jsContext.name = "Griffin Context"
        super.init()
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
