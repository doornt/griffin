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
        
        defer {
            _lock.unlock()
        }
        
        componentType = _componentConfigs[tag] as? ViewComponent.Type
        if componentType == nil {
            Log.Error("\(tag) does not registered with any class")
        }
        
        return componentType
    }
    
    func registerComponent(_ tag: String, withClass className:AnyClass) {
        
        _lock.lock()
        
        defer {
            _lock.unlock()
        }
        
        let component = _componentConfigs[tag] as? ViewComponent.Type
        if component != nil {
            Log.Warning("\(tag) has already been registered with class \(className)")
        }
        
        _componentConfigs[tag] = className
    }
}
