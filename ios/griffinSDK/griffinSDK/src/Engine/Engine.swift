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
        
       
        
        let registerEvent:@convention(block)(UIView, String, String)-> Void = {
            view, event, callBackString in
            RenderManager.instance.registerEvent(view, event: event, callBackString: callBackString)
        }
        
        JSCoreBridge.instance.getContext().setObject(unsafeBitCast(createViewScript,to: AnyObject.self) , forKeyedSubscript: "createView" as NSCopying & NSObjectProtocol)
        JSCoreBridge.instance.getContext().setObject(unsafeBitCast(createLabelScript,to: AnyObject.self) , forKeyedSubscript: "createLabel" as NSCopying & NSObjectProtocol)
        JSCoreBridge.instance.getContext().setObject(unsafeBitCast(createImageViewScript,to: AnyObject.self) , forKeyedSubscript: "createImageView" as NSCopying & NSObjectProtocol)
        JSCoreBridge.instance.getContext().setObject(unsafeBitCast(setRootViewScript,to: AnyObject.self) , forKeyedSubscript: "setRootView" as NSCopying & NSObjectProtocol)
        JSCoreBridge.instance.getContext().setObject(unsafeBitCast(useElementScript,to: AnyObject.self) , forKeyedSubscript: "useElement" as NSCopying & NSObjectProtocol)
        JSCoreBridge.instance.getContext().setObject(unsafeBitCast(addSubviewScript,to: AnyObject.self) , forKeyedSubscript: "addSubview" as NSCopying & NSObjectProtocol)
     
        JSCoreBridge.instance.getContext().setObject(unsafeBitCast(registerEvent, to: AnyObject.self),forKeyedSubscript: "registerEvent" as NSCopying & NSObjectProtocol)
        
      
    }
    
   
    
}
