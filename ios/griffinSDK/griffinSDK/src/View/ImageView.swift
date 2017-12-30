//
//  ImageView.swift
//  GriffinSDK
//
//  Created by sjtupt on 2017/12/26.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

class ImageView :UIImageView, ViewProtocol {
    
    func update(_ dict: Dictionary<String, Any>) {
        setup(dict)
    }
    
    convenience init(dict:Dictionary<String,Any>){
        self.init()
        self.isUserInteractionEnabled = false
        setup(dict)
    }
    
    func setup(_ dict:Dictionary<String,Any>) {
        
        config(dict)
        self.setGriffinImage(with: Utils.any2String(dict["url"]) ?? "")
        
        if self.layer.cornerRadius > 0 {
            self.layer.masksToBounds = true
        }
    }
}
