//
//  View.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/21.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

class View :UIView, ViewProtocol {

    public var id:String?
    
    convenience init(dict:Dictionary<String,Any>){
        self.init()
        self.id = dict["class"] as? String

        self.isUserInteractionEnabled = false
        config(dict: dict)
    }
    
    func updateView(dict: Dictionary<String, Any>) {
        config(dict: dict)
    }
}

