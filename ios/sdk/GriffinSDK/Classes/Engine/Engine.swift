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
        
        Log.logLevel = .Info
        
        initSDKEnviroment()
        
        #if DEBUG
        NotificationCenter.default.addObserver(self, selector: #selector(handleFileChanged(_:)), name: NSNotification.Name(rawValue: "FileChanged"), object: nil)
        DebugManager.start()
        #endif
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleFileChanged(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo,let script = userInfo["script"] as? String else {
            return
        }
        
        GnDispatchCenter.instance.handleFileChange(script)
    }
    
    private func initSDKEnviroment(){
        registerComponents()
        registerComponents2JS()
        registerMethod2JS()
    }
}

// MARK: - Register
private extension Engine {
    
    // MARK: - Register Components
    func registerComponents() {
        ComponentFactory.instance.registerComponent("div", withClass: DivView.self)
        ComponentFactory.instance.registerComponent("label", withClass: Label.self)
        ComponentFactory.instance.registerComponent("text", withClass: Label.self)
        ComponentFactory.instance.registerComponent("img", withClass: ImageView.self)
        ComponentFactory.instance.registerComponent("$wrapper", withClass: ComponentWrap.self)
        ComponentFactory.instance.registerComponent("slider", withClass: SliderView.self)
        ComponentFactory.instance.registerComponent("scrollView", withClass: ScrollComponent.self)
        ComponentFactory.instance.registerComponent("listView", withClass: List.self)
        ComponentFactory.instance.registerComponent("row", withClass: Row.self)
    }
    
    // MARK: - Register Components to JS
    func registerComponents2JS() {
        GnDispatchCenter.instance.registerComponent2JS("scrollView")
        GnDispatchCenter.instance.registerComponent2JS("listView")
        GnDispatchCenter.instance.registerComponent2JS("row")
    }
    
    func registerMethod2JS(){
        // MARK: Create View
        GnDispatchCenter.instance.register(method: { instanceId in
            self.createRootView(instanceId)
        } as @convention(block)(String)-> Void,
                                           script: "createRootView")
        
        GnDispatchCenter.instance.register(method: { rootViewId, instanceId, obj in
            self.createElementBlock(rootViewId, instanceId, obj)
        } as @convention(block)(String, String, Dictionary<String,Any>) -> Void,
                                           script: "createElement")
        
        GnDispatchCenter.instance.register(method: { rootViewId,instanceId in
            self.removeChildrenBlock(rootViewId, instanceId)
        } as @convention(block)(String,String) -> Void,
                                           script: "removeChildren")
        
        GnDispatchCenter.instance.register(method: { rootViewId, parentId, childId in
            self.addSubview(rootViewId, parentId, childId)
        } as @convention(block)(String, String, String)-> Void,
                                           script: "addSubview")
        
        GnDispatchCenter.instance.register(method: { rootViewId, parentId, childIds in
            self.addViews(rootViewId, parentId, childIds)
        } as @convention(block)(String, String, [String])-> Void,
                                           script: "addViews")
        
        GnDispatchCenter.instance.register(method: { rootViewId, instanceId, data in
            self.updateElement(rootViewId, instanceId, data)
        } as @convention(block)(String, String, Dictionary<String,Any>)-> Void,
                                           script: "updateView")
        
        GnDispatchCenter.instance.register(method: { rootViewId, instanceId, event, callBack in
            self.registerEvent(event, rootViewId, instanceId, callBack)
        } as @convention(block)(String, String, String, JSValue)-> Void,
                                           script: "registerEvent")
        
        GnDispatchCenter.instance.register(method: {rootViewId, instanceId, event, callBack in
            self.unRegisterEvent(event, rootViewId, instanceId, callBack)
        } as @convention(block)(String, String, String, JSValue)-> Void,
                                           script: "unRegisterEvent")
        
        GnDispatchCenter.instance.register(method: { url, params, callback in
            self.fetch(url, params, callback)
        } as @convention(block)(String,[String: String],JSValue)-> Void,
                                           script: "nativeFetch")

        GnDispatchCenter.instance.register(method: {
            url in
            return WebSocket.init(url)
        } as @convention(block) (String) -> WebSocket,
                                           script: "WebSocket")
        
        GnDispatchCenter.instance.register(method: {
            return Navigator.init()
        } as @convention(block) () -> Navigator,
                                           script: "Navigator")
    }
}

private extension Engine {
    func createRootView(_ obj: String) -> Void {
        GnDispatchCenter.instance.createRootView(obj)
    }
    
    func createElementBlock(_ rootViewId: String, _ instanceId: String, _ obj: Dictionary<String,Any>) -> Void {
        GnDispatchCenter.instance.createElement(rootViewId: rootViewId, instanceId: instanceId, withData: obj)
    }
    
    func removeChildrenBlock(_ rootViewId:String,_ instanceId:String) -> Void {
        GnDispatchCenter.instance.removeChildren(rootViewId: rootViewId, instanceId: instanceId)
    }
    
    func addSubview(_ rootViewId:String, _ parentId: String,_ childId: String)-> Void {
        GnDispatchCenter.instance.addElement(rootViewId: rootViewId, parentId: parentId, childId: childId)
    }
    
    func addViews(_ rootViewId:String,_ parentId: String, _ childIds:[String])-> Void {
        GnDispatchCenter.instance.addElements(rootViewId: rootViewId, parentId: parentId, childIds: childIds)
    }
    
    func updateElement(_ rootViewId:String, _ instanceId:String, _ data: Dictionary<String,Any>)-> Void {
        GnDispatchCenter.instance.updateElement(rootViewId: rootViewId, instanceId: instanceId, data: data)
    }
    
    // MARK: - Event
    func registerEvent(_ event:String, _ rootViewId:String, _ instanceId:String, _ callBack: JSValue)-> Void {
        GnDispatchCenter.instance.register(event: event, rootViewId: rootViewId, instanceId: instanceId, callBack: callBack)
    }
    
    func unRegisterEvent(_ event: String, _ rootViewId:String, _ instanceId: String, _ callBack:JSValue)-> Void {
        GnDispatchCenter.instance.unRegister(event: event, rootViewId: rootViewId, instanceId: instanceId, callBack: callBack)
    }
    
    // MARK: - Network
    func fetch(_ url: String, _ params:[String: String], _ callback:JSValue)-> Void {
        GnDispatchCenter.instance.fetch(url, params:params, callback:callback)
    }
}
