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
        
        let createRootView:@convention(block)(String)-> Void = {
            obj in
            DispatchQueue.main.async {
                RenderManager.instance.createRootView(instanceId:obj)
            }
        }
        
        let createViewScript:@convention(block)(String, Dictionary<String,Any>)-> Void = {
            instanceId, obj in
            DispatchQueue.main.async {
                RenderManager.instance.createView(instanceId, obj: obj)
            }
        }
        
        let createLabelScript:@convention(block)(String, Dictionary<String,Any>)-> Void = {
            instanceId, obj in
            DispatchQueue.main.async {
                RenderManager.instance.createLabel(instanceId, obj: obj)
            }
        }
        let createImageViewScript:@convention(block)(String, Dictionary<String,Any>)-> Void = {
            instanceId, obj in
            DispatchQueue.main.async {
                RenderManager.instance.createImageView(instanceId, obj:obj)
            }
        }
        
        let addSubviewScript:@convention(block)(String, String)-> Void = {
            parentId, childId in
            DispatchQueue.main.async {
                RenderManager.instance.addsubView(parentId, childId:childId)
            }
        }
        
        let updateSubviewScript:@convention(block)(String, Dictionary<String,Any>)-> Void = {
            instanceId, data in
            DispatchQueue.main.async {
                RenderManager.instance.updateView(instanceId, data: data)
            }
        }
        
        let registerEvent:@convention(block)(String, String, JSValue)-> Void = {
            instanceId, event, callBack in
            DispatchQueue.main.async {
                RenderManager.instance.registerEvent(instanceId, event: event, callBack: callBack)
            }
        }
        
        let unRegisterEvent:@convention(block)(String, String, JSValue)-> Void = {
            instanceId, event, callBack in
            DispatchQueue.main.async {
                RenderManager.instance.unRegisterEvent(instanceId, event: event, callBack: callBack)
            }
        }
        
        JSCoreBridge.instance.registerCallMethod(method: createRootView, script: "createRootView")
        JSCoreBridge.instance.registerCallMethod(method: createViewScript, script: "createView")
        JSCoreBridge.instance.registerCallMethod(method: createLabelScript, script: "createLabel")
        JSCoreBridge.instance.registerCallMethod(method: createImageViewScript, script: "createImageView")
    
        JSCoreBridge.instance.registerCallMethod(method: addSubviewScript, script: "addSubview")
        JSCoreBridge.instance.registerCallMethod(method: updateSubviewScript, script: "updateView")
        JSCoreBridge.instance.registerCallMethod(method: registerEvent, script: "registerEvent")
        JSCoreBridge.instance.registerCallMethod(method: unRegisterEvent, script: "unRegisterEvent")
    }
    
   
    
}
