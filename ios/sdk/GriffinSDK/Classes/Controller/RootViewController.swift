//
//  RootViewController.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/21.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

public class RootViewController : UINavigationController{
    
    public convenience init(){
        let root = BaseViewController.init()
        self.init(rootViewController: root)
        ComponentManager.instance.setRootController(root: root)
    }
    
    
}
