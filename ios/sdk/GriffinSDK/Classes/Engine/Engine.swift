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
    
    private var _jsCore:JSBridgeContext?
    
    public func initSDK(){
        let _ = DebugManager.instance

        self._jsCore = JSBridgeContext.instance
        
        initSDKEnviroment()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFileChanged(_:)), name: NSNotification.Name(rawValue: "FileChanged"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleFileChanged(_ notification: Notification) {
        ComponentManager.instance.unload()
        self.script = notification.userInfo!["script"] as! String
        JSBridgeContext.instance.performOnJSThread {
            JSBridgeContext.instance.executeJavascript(script: self.script)
        }
    }
    
    private func initSDKEnviroment(){
        registerDefault()
    }
}

// MARK: - Register
private extension Engine {
    
    func registerDefault() {
        registerComponents()
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
        JSBridgeContext.instance.performOnJSThread {
            JSBridgeContext.instance.register(method: {
                url in
                return WebSocket.init(url)
            } as @convention(block) (String) -> WebSocket, script: "WebSocket")
            
            JSBridgeContext.instance.register(method: { return Navigator.init() } as @convention(block) () -> Navigator, script: "Navigator")
        }
    }
}
