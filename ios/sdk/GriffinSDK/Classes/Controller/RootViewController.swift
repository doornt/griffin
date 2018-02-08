//
//  RootViewController.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/21.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

public class RootViewController : UINavigationController{
    
    public convenience init(withSourceURL url: String) {
        let root = BaseViewController.init(sourceUrl: url)
        self.init(rootViewController: root)
    }
}
