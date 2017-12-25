//
//  RootViewController.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/21.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

public class RootViewController : UINavigationController{
    
    public convenience init(url:URL?){
        let root = BaseViewController.init(url: url)
        self.init(rootViewController: root)
        RenderManager.instance.setRootController(root: root)
    }
}
