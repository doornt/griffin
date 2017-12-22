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
        
        JSCoreBridge.instance.getContext().setObject(unsafeBitCast(createViewScript,to: AnyObject.self) , forKeyedSubscript: "createView" as NSCopying & NSObjectProtocol)
        JSCoreBridge.instance.getContext().setObject(unsafeBitCast(createLabelScript,to: AnyObject.self) , forKeyedSubscript: "createLabel" as NSCopying & NSObjectProtocol)
        JSCoreBridge.instance.getContext().setObject(unsafeBitCast(createImageViewScript,to: AnyObject.self) , forKeyedSubscript: "createImageView" as NSCopying & NSObjectProtocol)
        JSCoreBridge.instance.getContext().setObject(unsafeBitCast(useElementScript,to: AnyObject.self) , forKeyedSubscript: "useElement" as NSCopying & NSObjectProtocol)
        
    }
    
   
    
}
