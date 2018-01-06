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
            ComponentManager.instance.createRootView(obj)
        }
    }
    
    private let createElementBlock:@convention(block)(String, Dictionary<String,Any>) -> Void = {
        instanceId, obj in
        DispatchQueue.main.async {
            ComponentManager.instance.createElement(instanceId, withData: obj)
        }
    }
    
    private let addSubview:@convention(block)(String, String)-> Void = {
        parentId, childId in
        DispatchQueue.main.async {
            ComponentManager.instance.addElement(parentId, childId:childId)
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
        registerComponent("div", withClass: DivView.self)
        registerComponent("text", withClass: Label.self)
        registerComponent("img", withClass: ImageView.self)
    }
    
    func registerComponent(_ tag: String, withClass className: AnyClass) {
        ComponentFactory.instance.registerComponent(tag, withClass: className)
    }
    
    func registerNativeMethods() {
        
        JSCoreBridge.instance.register(method: createElementBlock, script: "createElement")
        
        // MARK: Create View
        JSCoreBridge.instance.register(method: createRootView, script: "createRootView")
     
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
