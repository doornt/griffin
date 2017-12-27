//
//  Environment.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2017/12/23.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

class Environment {
    
    let screenWidth  = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    static let instance:Environment = {
        return Environment()
    }()
    
    func get() -> [String:Any]{
        var env = [String:Any]()
        env["platform"] = "ios"
        env["screenWidth"] = screenWidth
        env["screenHeight"] = screenHeight
        return env
    }
}
