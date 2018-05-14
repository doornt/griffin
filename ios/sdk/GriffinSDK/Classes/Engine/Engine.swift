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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFileChanged(_:)), name: NSNotification.Name(rawValue: "FileChanged"), object: nil)
        DebugManager.start()
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
        registerDefault()
    }
}

// MARK: - Register
private extension Engine {
    
    func registerDefault() {
        registerComponents()
        registerComponents2JS()
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
        GnDispatchCenter.instance.registerComponent2JS("scrollView")
    }
}
