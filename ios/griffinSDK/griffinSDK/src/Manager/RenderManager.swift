//
//  RenderManager.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/8.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit
import JavaScriptCore

class RenderManager {
    
    var _rootController:BaseViewController?
    
    private var viewCollection: [String: UIView] = Dictionary()
    
    static let instance:RenderManager = {
        return RenderManager()
    }()
    
    func setRootController(root:BaseViewController){
        self._rootController = root
    }
}

//MARK: - Elements Operations
extension RenderManager {
    func updateView(_ instanceId:String, data: Dictionary<String,Any>) {
        guard let view = viewCollection[instanceId] else {
            return
        }
        (view as? ViewProtocol )?.update(data)
    }
}

// MARK: - Event
extension RenderManager {
    func register(event:String, instanceId:String,  callBack: JSValue){
        guard let view = viewCollection[instanceId] else {
            return
        }
        
        view.register(event: event, callBack: callBack)
    }
    
    func unRegister(event: String, instanceId:String, callBack: JSValue){
        guard let view = viewCollection[instanceId] else {
            return
        }
        view.unRegister(event: event, callBack: callBack)
    }
}
