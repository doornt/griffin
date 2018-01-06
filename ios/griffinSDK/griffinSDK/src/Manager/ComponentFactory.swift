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
    
    private let lock = NSLock()
    var componentConfigs = [String: AnyObject.Type]()
    
    private init() {}
    
    func registerComponent(_ tag: String, withClass className:AnyClass) {
        
        lock.lock()
        
        let component = componentConfigs[tag]
        if component != nil {
            print("\(tag) has already been registered with class \(className)")
        }
        
        componentConfigs[tag] = className
        
        lock.unlock()
    }
}
