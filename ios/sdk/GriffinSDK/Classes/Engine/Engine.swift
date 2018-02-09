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
    
    private var script:String = ""
    
    private var _jsCore:JSCoreBridge?
    
    public func initSDK(){
        let _ = DebugManager.instance

        self._jsCore = JSCoreBridge.instance
        
        initSDKEnviroment()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFileChanged(_:)), name: NSNotification.Name(rawValue: "FileChanged"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleFileChanged(_ notification: Notification) {
        ComponentManager.instance.unload()
        self.script = notification.userInfo!["script"] as! String
        JSCoreBridge.instance.performOnJSThread {
            JSCoreBridge.instance.executeJavascript(script: self.script)
        }
    }
    
    private func initSDKEnviroment(){
        registerDefault()
    }
    
    // MARK: - Component
    private let createRootView:@convention(block)(String)-> Void = {
        obj in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.createRootView(obj)
        }
    }
    
    private let createElementBlock:@convention(block)(String, String, Dictionary<String,Any>) -> Void = {
        rootViewId, instanceId, obj in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.createElement(rootViewId: rootViewId, instanceId: instanceId, withData: obj)
        }
    }
    
    private let addSubview:@convention(block)(String, String, String)-> Void = {
        rootViewId, parentId, childId in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.addElement(rootViewId: rootViewId, parentId: parentId, childId: childId)
        }
    }
    
    private let updateElement:@convention(block)(String, String, Dictionary<String,Any>)-> Void = {
        rootViewId, instanceId, data in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.updateElement(rootViewId: rootViewId, instanceId: instanceId, data: data)
        }
    }
    
    // MARK: - Event
    private let registerEvent:@convention(block)(String, String, String, JSValue)-> Void = {
        rootViewId, instanceId, event, callBack in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.register(event: event, rootViewId: rootViewId, instanceId: instanceId, callBack: callBack)
        }
    }
    
    private let unRegisterEvent:@convention(block)(String, String, String, JSValue)-> Void = {
        rootViewId, instanceId, event, callBack in
        ComponentManager.instance.performOnComponentThread {
            ComponentManager.instance.unRegister(event: event, rootViewId: rootViewId, instanceId: instanceId, callBack: callBack)
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
        id, animated, callback in
        DispatchQueue.main.async {
            RootComponentManager.instance.pushViewController(withId: id, animated: animated)
//            let vc = BaseViewController.init(sourceUrl: url)
//            ComponentManager.instance.controllerHost?.vc?.navigationController?.pushViewController(vc, animated: animated)
        }
    }
    
    private let navigatorPop:@convention(block)(Bool, JSValue)-> Void = {
        animated, callback in
        DispatchQueue.main.async {
            print(animated)
            RootComponentManager.instance.popViewController(animated: animated)
//            ComponentManager.instance.controllerHost?.vc?.navigationController?.popViewController(animated: animated)
        }
    }
}

// MARK: - Register
private extension Engine {
    
    func registerDefault() {
        registerComponents()
        registerNativeMethods()
        registerModules()
    }
    
    // MARK: - Register Component
    func registerComponents() {
        registerComponent("div", withClass: DivView.self)
        registerComponent("label", withClass: Label.self)
        registerComponent("text", withClass: Label.self)
        registerComponent("img", withClass: ImageView.self)
    }
    
    func registerComponent(_ tag: String, withClass className: AnyClass) {
        ComponentFactory.instance.registerComponent(tag, withClass: className)
    }
    
    func registerModules(){
        JSCoreBridge.instance.performOnJSThread {
            JSCoreBridge.instance.register(method: {
                url in
                return WebSocket.init(url)
            } as @convention(block) (String) -> WebSocket, script: "WebSocket")
        }
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
