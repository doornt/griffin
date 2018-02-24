//
//  JSCoreBridge.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/2/11.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation
import JavaScriptCore

extension JSCoreBridge {
    
    func executeJavascript(script:String) -> JSValue{
        return _jsContext.evaluateScript(script)
    }
    
    func executeJavascript(script:String, withSourceUrl url:URL) -> JSValue{
        return _jsContext.evaluateScript(script, withSourceURL: url)
    }
    
    func callJsMethod(dict:[String: Any]) -> JSValue {
        return _jsContext.globalObject.invokeMethod(Utils.any2String(dict["method"]), withArguments: dict["args"] as! [Any])
    }

    func register<T>(method:T,script:String){
        _jsContext.setObject(unsafeBitCast(method,to: AnyObject.self) , forKeyedSubscript: script as NSCopying & NSObjectProtocol)
    }
}

class JSCoreBridge: NSObject {
    
    private let _jsContext:JSContext = {
        let context:JSContext = JSContext(virtualMachine: JSVirtualMachine())
        context.name = "Griffin Context"
        return context
    }()
    
    override init() {
        super.init()
        self.initEnvironment()
        self.initJsFunctions()
    }
    
    private func initEnvironment(){
        _jsContext.setObject(Environment.instance.get(), forKeyedSubscript: "Environment" as NSCopying & NSObjectProtocol)
    }
    
    private func initJsFunctions(){
        let timeoutFunc:@convention(block)(JSValue,Double) ->Void = {
            [unowned self](cb,wait) in
            self.perform(#selector(self.timerHandler(_:)), with: cb, afterDelay: TimeInterval(wait / 1000))
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
            DebugManager.instance.logToServer("JS\(key):\(message)\n")
            print("JS\(key):\(message)\n")
        }
        _jsContext.setObject(unsafeBitCast(consoleLog, to: AnyObject.self),forKeyedSubscript: "NativeLog" as NSCopying & NSObjectProtocol)
        
        _jsContext.exceptionHandler = {(ctx: JSContext!, value: JSValue!) in
            let stacktrace = value.objectForKeyedSubscript("stack").toString()
            let lineNumber = value.objectForKeyedSubscript("line")
            let column = value.objectForKeyedSubscript("column")
            let moreInfo = "in method \(String(describing: stacktrace))Line number in file: \(String(describing: lineNumber)), column: \(String(describing: column))"
            
            DebugManager.instance.logToServer("\nJS ERROR: \(value) \(moreInfo)")
            print("\nJS ERROR: \(value) \(moreInfo)")
        }
    }
    
    @objc private func timerHandler(_ cb: JSValue?) {
        guard let callback = cb else {
            return
        }
        callback.call(withArguments: [])
    }
}
