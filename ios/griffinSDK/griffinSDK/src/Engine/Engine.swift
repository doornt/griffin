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
        
    private override init() {
        super.init()
    }
    
    public func initSDK(){
        let runWithModuleScript:@convention(block)(Dictionary<String,Any>)-> Void = {
            obj in
            RenderManager.instance.runWithModule(obj:obj)
        }
        JSCoreBridge.instance.getContext().setObject(unsafeBitCast(runWithModuleScript,to: AnyObject.self) , forKeyedSubscript: "runWithModule" as NSCopying & NSObjectProtocol)
    }
    
   
    
}
