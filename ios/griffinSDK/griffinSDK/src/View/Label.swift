//
//  Label.swift
//  GriffinSDK
//
//  Created by sjtupt on 2017/12/26.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

class Label :UILabel, ViewProtocol {
    
    func updateView(dict: Dictionary<String, Any>) {
        buildLabel(dict: dict)
    }

    convenience init(dict:Dictionary<String,Any>){
        self.init()
        self.isUserInteractionEnabled = false
        buildLabel(dict: dict)
    }
    
    func buildLabel(dict:Dictionary<String,Any>) {
        
        config(dict: dict)
        
        self.text = Utils.any2String(obj: dict["text"])
        
        if Utils.hexString2UIColor(hex: Utils.any2String(obj: dict["textColor"])) != nil {
            self.textColor = Utils.hexString2UIColor(hex: Utils.any2String(obj: dict["textColor"]))
        }
        
        if self.layer.cornerRadius > 0 {
            self.layer.masksToBounds = true
        }
        self.sizeToFit()
    }
}
