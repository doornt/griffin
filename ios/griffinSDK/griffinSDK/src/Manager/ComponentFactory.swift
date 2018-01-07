//
//  ComponentFactory.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/1/5.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class ComponentFactory {
    static let instance = ComponentFactory()
    
    private let _lock = NSLock()
    private var _componentConfigs = [String: AnyClass]()
    
    private init() {}
    
    func component(withTag tag: String) -> AnyClass? {
        
        var componentType: AnyClass? = nil
        
        _lock.lock()
        
        componentType = _componentConfigs[tag] as? ViewComponent.Type
        if componentType == nil {
            Log.ErrorLog("\(tag) does not registered with any class")
        }
        
        _lock.unlock()
        
        return componentType
    }
    
    func registerComponent(_ tag: String, withClass className:AnyClass) {
        
        _lock.lock()
        
        let component = _componentConfigs[tag] as? ViewComponent.Type
        if component != nil {
            Log.WarningLog("\(tag) has already been registered with class \(className)")
        }
        
        Log.InfoLog("\(tag) has been registered with class \(className) successfully")
        
        _componentConfigs[tag] = className
        
        _lock.unlock()
    }
}
