//
//  Label.swift
//  GriffinSDK
//
//  Created by sjtupt on 2017/12/26.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

class Label :UILabel, ViewProtocol {
    
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
        
        self.text = Utils.any2String(dict["text"])
        
        if Utils.hexString2UIColor(Utils.any2String(dict["textColor"])) != nil {
            self.textColor = Utils.hexString2UIColor(Utils.any2String(dict["textColor"]))
        }
        
        if self.layer.cornerRadius > 0 {
            self.layer.masksToBounds = true
        }
        self.sizeToFit()
    }
}
