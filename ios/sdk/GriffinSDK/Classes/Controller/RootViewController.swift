//
//  RootViewController.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/21.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

public class RootViewController : UINavigationController, UIGestureRecognizerDelegate{
    
    convenience init() {
        let root = BaseViewController.init()
        self.init(rootViewController: root)
        RootComponentManager.instance.rootController = root
    }
    
    public convenience init(withSourceURL url: String) {
        let root = BaseViewController.init(sourceUrl: url)
        self.init(rootViewController: root)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarHidden(true, animated: true)
        
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count == 1 {
            return false
        }
        return true
    }
    
    public override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        
        let _ = RootComponentManager.instance.pop()
        
        return vc
    }
}
