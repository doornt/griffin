//
//  Engine.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/21.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import JavaScriptCore

public class Engine: NSObject {
    
    public static let instance:Engine = {
        return Engine()
    }()
    
    let _engine:Engine
    
    private override init() {
        self._engine = Engine()
        super.init()
    }
    
    public func initSDK(){
        JSCoreBridge.instance.registerHanler()
    }
    
   
    
}
