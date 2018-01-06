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
    
    func createRootView(_ instanceId:String) -> Void {
        let component = DivView.init(ref: instanceId, styles: ["background-color":"#FF0000",
                                                               "height":Environment.instance.screenHeight,
                                                               "width":Environment.instance.screenWidth,
                                                               "top":0,
                                                               "left":0])
        _indexDict[instanceId] = component
        
        RenderManager.instance._rootController?.setRootView(component.loadView())
    }
    
    func createElement(_ instanceId: String, withData componentData:[String: Any]) {
        let _ = _buildComponent(instanceId, withData:componentData)
    }
    
    func addElement(_ parentId:String, childId: String){
        guard let superComponent = _indexDict[parentId],
              let childComponent = _indexDict[childId] else {
            return
        }
        superComponent.addChild(childComponent)
    }
    
    func _buildComponent(_ instanceId: String, withData data:[String: Any]) -> ViewComponent? {
        
        guard let type = Utils.any2String(data["type"]) else {
            return nil
        }
        
        guard let typeClass = ComponentFactory.instance.componentConfigs[type] as? ViewComponent.Type else {
            return nil
        }

        let viewComponent: ViewComponent =  typeClass.init(ref: instanceId, styles: data)
        _indexDict[instanceId] = viewComponent
        return viewComponent
    }
    
}
