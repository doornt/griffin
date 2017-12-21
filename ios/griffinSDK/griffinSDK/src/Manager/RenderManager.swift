//
//  RenderManager.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/8.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

public class RenderManager : NSObject{
    
    var _rootController:BaseViewController?
    
    public static let instance:RenderManager = {
        return RenderManager()
    }()
    
    private override init() {
        super.init()
    }
    
    public func setRootController(root:BaseViewController){
        self._rootController = root
    }
    
    public func runWithModule(obj:Dictionary<String,Any>){
        self._rootController?.view.addSubview(View.init(dict: obj))
    }
}
