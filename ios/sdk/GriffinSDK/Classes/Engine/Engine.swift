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
    
    // MARK: - Component
    private let createRootView:@convention(block)(String)-> Void = {
        obj in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.createRootView(obj)
        }
    }
    
    private let createElementBlock:@convention(block)(String, Dictionary<String,Any>) -> Void = {
        instanceId, obj in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.createElement(instanceId, withData: obj)
        }
    }
    
    private let addSubview:@convention(block)(String, String)-> Void = {
        parentId, childId in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.addElement(parentId, childId:childId)
        }
    }
    
    private let updateElement:@convention(block)(String, Dictionary<String,Any>)-> Void = {
        instanceId, data in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.updateElement(instanceId, data: data)
        }
    }
    
    // MARK: - Event
    private let registerEvent:@convention(block)(String, String, JSValue)-> Void = {
        instanceId, event, callBack in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.register(event: event, instanceId: instanceId, callBack: callBack)
        }
    }
    
    private let unRegisterEvent:@convention(block)(String, String, JSValue)-> Void = {
        instanceId, event, callBack in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.unRegister(event: event, instanceId: instanceId, callBack: callBack)
        }
    }
    
    // MARK: - Network
    private let fetch:@convention(block)(String, [String: String], JSValue)-> Void = {
        url, params, callback in
        DispatchQueue.main.async {
            NetworkManager.instance.get(url: url, params: params) {
                (data, error) in
                callback.callWithArguments(data)
            }
        }
    }
    
    private let navigatorPush:@convention(block)(String, Bool, JSValue)-> Void = {
        url, animated, callback in
        DispatchQueue.main.async {
            print("\(animated) \(url)")
        }
    }
    
    private let navigatorPop:@convention(block)(Bool, JSValue)-> Void = {
        animated, callback in
        DispatchQueue.main.async {
            print(animated)
        }
    }
}

// MARK: - Register
private extension Engine {
    
    func registerDefault() {
        registerComponents()
        registerNativeMethods()
    }
    
    // MARK: - Register Component
    func registerComponents() {
        registerComponent("div", withClass: DivView.self)
        registerComponent("label", withClass: Label.self)
        registerComponent("img", withClass: ImageView.self)
    }
    
    func registerComponent(_ tag: String, withClass className: AnyClass) {
        ComponentFactory.instance.registerComponent(tag, withClass: className)
    }
    
    // MARK: - Register Methods
    func registerNativeMethods() {
        
        // MARK: Create View
        JSCoreBridge.instance.register(method: createRootView, script: "createRootView")
        JSCoreBridge.instance.register(method: createElementBlock, script: "createElement")
        
        // MARK: Operate View
        JSCoreBridge.instance.register(method: addSubview, script: "addSubview")
        JSCoreBridge.instance.register(method: updateElement, script: "updateView")
        
        // MARK: Event
        JSCoreBridge.instance.register(method: registerEvent, script: "registerEvent")
        JSCoreBridge.instance.register(method: unRegisterEvent, script: "unRegisterEvent")
        
        // MARK: Network
        JSCoreBridge.instance.register(method: fetch, script: "fetch")
        
        JSCoreBridge.instance.register(method: navigatorPush, script: "NavigatorPush")
        JSCoreBridge.instance.register(method: navigatorPop, script: "NavigatorPop")
    }
}
