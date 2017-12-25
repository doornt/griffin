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
        
        let setRootViewScript:@convention(block)(Any)-> Void = {
            obj in
            return RenderManager.instance.setRootView(obj:obj)
        }
        
        let createViewScript:@convention(block)(Dictionary<String,Any>)-> View = {
            obj in
            return RenderManager.instance.createView(obj:obj)
        }
        
        let createLabelScript:@convention(block)(Dictionary<String,Any>)-> Label = {
            obj in
            return RenderManager.instance.createLabel(obj:obj)
        }
        let createImageViewScript:@convention(block)(Dictionary<String,Any>)-> ImageView = {
            obj in
            return RenderManager.instance.createImageView(obj:obj)
        }
        
        let useElementScript:@convention(block)(Any)-> Void = {
            obj in
            RenderManager.instance.useElement(obj:obj)
        }
        let addSubviewScript:@convention(block)(Any, Any)-> Void = {
            parentView, childView in
            RenderManager.instance.addsubView(parentView, childView:childView)
        }
        
        let updateSubviewScript:@convention(block)(Any, Dictionary<String,Any>)-> Void = {
            view, data in
            RenderManager.instance.updateView(view, data: data)
        }
       
        
        let registerEvent:@convention(block)(UIView, String, JSValue)-> Void = {
            view, event, callBack in
            RenderManager.instance.registerEvent(view, event: event, callBack: callBack)
        }
        
        
        JSCoreBridge.instance.registerCallMethod(method: createViewScript, script: "createView")
        JSCoreBridge.instance.registerCallMethod(method: createLabelScript, script: "createLabel")
        JSCoreBridge.instance.registerCallMethod(method: createImageViewScript, script: "createImageView")
        JSCoreBridge.instance.registerCallMethod(method: setRootViewScript, script: "setRootView")
        JSCoreBridge.instance.registerCallMethod(method: useElementScript, script: "useElement")
        JSCoreBridge.instance.registerCallMethod(method: addSubviewScript, script: "addSubview")
        JSCoreBridge.instance.registerCallMethod(method: updateSubviewScript, script: "updateView")
        JSCoreBridge.instance.registerCallMethod(method: registerEvent, script: "registerEvent")
    }
    
   
    
}
