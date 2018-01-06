//
//  ComponentManager.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/1/6.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class ComponentManager {
    
    private init() {}
    
    static let instance = ComponentManager()
    
    private var _indexDict = [String: ViewComponent]()
    
    func addComponent(_ componentData:[String: Any], toSupercomponent superRef: String, atIndex index: NSInteger, appendingInTree: Bool) {
        
        guard let supercomponent = _indexDict[superRef] else {
            return
        }
        
        self._recursivelyAddComponent(componentData, toSupercomponent: supercomponent, atIndex: index, appendingInTree: appendingInTree)
    }
    
    func _recursivelyAddComponent(_ componentData:[String: Any], toSupercomponent: ViewComponent, atIndex index: NSInteger, appendingInTree: Bool) {
        
        let component = _buildComponentForData(componentData, supercomponent: toSupercomponent)
        
        guard let newComponent = component else {
            return
        }
        toSupercomponent.addChild(newComponent)
    }
    
    func _buildComponentForData(_ data:[String: Any] ,supercomponent:ViewComponent) -> ViewComponent? {
        
        guard let ref = Utils.any2String(data["ref"]),
              let type = Utils.any2String(data["type"]) else {
            return nil
        }
        
        let clazz = NSClassFromString(type) as! ViewComponent.Type
        let viewComponent: ViewComponent =  clazz.init(ref: ref, styles: data)
        _indexDict[ref] = viewComponent
        return viewComponent
    }
    
}
