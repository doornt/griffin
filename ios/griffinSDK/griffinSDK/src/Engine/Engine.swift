//
//  Engine.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/21.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import JavaScriptCore

public class Engine {
    
    public static let instance:Engine = {
        return Engine()
    }()
    
    public func initSDK(){
        registerDefault()
    }
    
    // MARK: - Native Methods
    private let createRootView:@convention(block)(String)-> Void = {
        obj in
        DispatchQueue.main.async {
            RenderManager.instance.createRootView(obj)
        }
    }
    
    private let addElementBlock:@convention(block)(JSValue, JSValue, JSValue, JSValue, JSValue) -> Void = {
        (instanceId, ref, element, index, ifCallback) in
        
        
        DispatchQueue.main.async {
            
            let instanceIdString = instanceId.toString()
            let componentData = element.toDictionary()
            let parentRef = ref.toString()
            let insertIndex = index.toInt32()
            
            ComponentManager.instance.addComponent(componentData as! [String : Any], toSupercomponent: parentRef!, atIndex: NSInteger(insertIndex), appendingInTree: false)
        }
        
    }
    
//    private let createView:@convention(block)(String, Dictionary<String,Any>)-> Void = {
//        instanceId, obj in
//        DispatchQueue.main.async {
//            RenderManager.instance.createView(instanceId, obj: obj)
//        }
//    }
//    
//    private let createLabel:@convention(block)(String, Dictionary<String,Any>)-> Void = {
//        instanceId, obj in
//        DispatchQueue.main.async {
//            RenderManager.instance.createLabel(instanceId, obj: obj)
//        }
//    }
//    private let createImageView:@convention(block)(String, Dictionary<String,Any>)-> Void = {
//        instanceId, obj in
//        DispatchQueue.main.async {
//            RenderManager.instance.createImageView(instanceId, obj:obj)
//        }
//    }
    
    private let addSubview:@convention(block)(String, String)-> Void = {
        parentId, childId in
        DispatchQueue.main.async {
            RenderManager.instance.addSubView(parentId, childId:childId)
        }
    }
    
    private let updateSubview:@convention(block)(String, Dictionary<String,Any>)-> Void = {
        instanceId, data in
        DispatchQueue.main.async {
            RenderManager.instance.updateView(instanceId, data: data)
        }
    }
    
    private let registerEvent:@convention(block)(String, String, JSValue)-> Void = {
        instanceId, event, callBack in
        DispatchQueue.main.async {
            RenderManager.instance.register(event: event, instanceId: instanceId, callBack: callBack)
        }
    }
    
    private let unRegisterEvent:@convention(block)(String, String, JSValue)-> Void = {
        instanceId, event, callBack in
        DispatchQueue.main.async {
            RenderManager.instance.unRegister(event: event, instanceId: instanceId, callBack: callBack)
        }
    }
    
    private let fetch:@convention(block)(String, [String: String], JSValue)-> Void = {
        url, params, callback in
        DispatchQueue.main.async {
            NetworkManager.instance.get(url: url, params: params) {
                (data, error) in
                callback.callWithArguments(data)
            }
        }
    }
}

// MARK: - RegisterNativeMethods
private extension Engine {
    
    func registerDefault() {
        registerComponents()
        registerNativeMethods()
    }
    
    func registerComponents() {
        registerComponent("div", withClass: "DivView")
        registerComponent("text", withClass: "Label")
        registerComponent("img", withClass: "ImageView")
    }
    
    func registerComponent(_ tag: String, withClass className:String) {
        ComponentFactory.instance.registerComponent(tag, withClass: className)
    }
    
    func registerNativeMethods() {
        
        JSCoreBridge.instance.register(method: addElementBlock, script: "addElement")
        
        // MARK: Create View
        JSCoreBridge.instance.register(method: createRootView, script: "createRootView")
//        JSCoreBridge.instance.register(method: createView, script: "createView")
//        JSCoreBridge.instance.register(method: createLabel, script: "createLabel")
//        JSCoreBridge.instance.register(method: createImageView, script: "createImageView")
        
        // MARK: Operate View
        JSCoreBridge.instance.register(method: addSubview, script: "addSubview")
        JSCoreBridge.instance.register(method: updateSubview, script: "updateView")
        
        // MARK: Event
        JSCoreBridge.instance.register(method: registerEvent, script: "registerEvent")
        JSCoreBridge.instance.register(method: unRegisterEvent, script: "unRegisterEvent")
        
        // MARK: Network
        JSCoreBridge.instance.register(method: fetch, script: "fetch")
    }
}
