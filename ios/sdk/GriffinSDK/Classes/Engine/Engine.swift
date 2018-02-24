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
    
    private lazy var _jsCore:JSBridgeContext? = {
        let jsCore = JSBridgeContext.instance
        return jsCore
    }()
    
    public func initSDK(){
        
        initSDKEnviroment()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFileChanged(_:)), name: NSNotification.Name(rawValue: "FileChanged"), object: nil)
        DebugManager.start()
        
//        sleep(30)
//        print("sleep end")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleFileChanged(_ notification: Notification) {
//        print("sleep file changed")
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
        registerComponents2JS()
        registerModules()
    }
    
    // MARK: - Register Components
    func registerComponents() {
        registerComponent("div", withClass: DivView.self)
        registerComponent("label", withClass: Label.self)
        registerComponent("text", withClass: Label.self)
        registerComponent("img", withClass: ImageView.self)
        registerComponent("$wrapper", withClass: ComponentWrap.self)
        
        registerComponent("slider", withClass: SliderView.self)
        registerComponent("scrollView", withClass: ScrollComponent.self)
    }
    
    func registerComponent(_ tag: String, withClass className: AnyClass) {
        ComponentFactory.instance.registerComponent(tag, withClass: className)
    }
    
    // MARK: - Register Components to JS
    func registerComponents2JS() {
        JSBridgeContext.instance.performOnJSThread {
            JSBridgeContext.instance.registerComponent2JS("scrollView")
        }
    }
    // MARK: - Regsiter Modules
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
