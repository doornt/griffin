//
//  JSCore.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/20.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import Foundation

import JavaScriptCore


class JSCoreBridge: NSObject {
    
    public static let instance:JSCoreBridge = {
        return JSCoreBridge()
    }()
    
    let _jsContext:JSContext
    
    private override init() {
        self._jsContext = JSContext()
        self._jsContext.name = "Griffin Context"
        super.init()
    }
    
    public func executeJavascript(script:String){
        _jsContext.evaluateScript(script)
    }
    
}
