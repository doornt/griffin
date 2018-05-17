//
//  GnDispatchCenter.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/5/14.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation
import JavaScriptCore

class GnDispatchCenter {
    
    public func handleFileChange(_ script: String) {
        
        GnThreadPool.instance.performOnMainThreadSync {
            RootComponentManager.instance.removeAllRootComponents()
            ComponentManager.instance.removeAllUITask()
        }
        
        GnThreadPool.instance.performOnJSThread {
            JSBridgeContext.instance.executeJavascript(script: script)
        }
    }
    
    public static let instance: GnDispatchCenter = {
        return GnDispatchCenter()
    }()
}

extension GnDispatchCenter {
    public func createRootView(_ instanceId:String) {
        GnThreadPool.instance.performOnComponentThread {
            ComponentManager.instance.createRootView(instanceId)
        }
    }
    
    func createElement(rootViewId: String, instanceId: String, withData componentData:[String: Any]) {
        GnThreadPool.instance.performOnComponentThread {
            ComponentManager.instance.createElement(rootViewId: rootViewId, instanceId: instanceId, withData: componentData)
        }
    }
    
    func removeChildren(rootViewId: String,instanceId: String) {
        GnThreadPool.instance.performOnComponentThread {
            ComponentManager.instance.removeChildren(rootViewId: rootViewId,instanceId: instanceId)
        }
    }
    
    func updateElement(rootViewId: String, instanceId:String, data: Dictionary<String,Any>) {
        GnThreadPool.instance.performOnComponentThread {
            ComponentManager.instance.updateElement(rootViewId: rootViewId, instanceId: instanceId, data: data)
        }
    }
    
    func addElement(rootViewId: String, parentId:String, childId: String){
        GnThreadPool.instance.performOnComponentThread {
            ComponentManager.instance.addElement(rootViewId: rootViewId, parentId: parentId, childId: childId)
        }
    }
    
    func addElements(rootViewId: String, parentId:String, childIds: [String]){
        GnThreadPool.instance.performOnComponentThread {
            ComponentManager.instance.addElements(rootViewId: rootViewId, parentId: parentId, childIds: childIds)
        }
    }
}

extension GnDispatchCenter {
    
    func register(event:String, rootViewId:String, instanceId:String,  callBack: JSValue){
        GnThreadPool.instance.performOnComponentThread {
            ComponentManager.instance.register(event: event, rootViewId: rootViewId, instanceId: instanceId, callBack: callBack)
        }
    }
    
    func unRegister(event: String, rootViewId:String, instanceId:String, callBack: JSValue){
        GnThreadPool.instance.performOnComponentThread {
            ComponentManager.instance.unRegister(event: event, rootViewId: rootViewId, instanceId: instanceId, callBack: callBack)
        }
    }
}

extension GnDispatchCenter {
    func fetch(_ url: String, params:[String: String], callback:JSValue) {
        DispatchQueue.global().async {
            NetworkManager.instance.get(url: url, params: params) {
                (data, error) in
                GnThreadPool.instance.performOnJSThread {
                    callback.callWithAny(data)
                }
            }
        }
    }
}
extension GnDispatchCenter {
    func registerComponent2JS(_ component: String) {
        GnThreadPool.instance.performOnJSThreadSync {
            JSBridgeContext.instance.registerComponent2JS(component)
        }
    }
    
    func register<T>(method:T,script:String){
        GnThreadPool.instance.performOnJSThreadSync {

            JSBridgeContext.instance.register(method: method, script: script)
        }
    }
}
