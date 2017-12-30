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
    
    lazy var homePath = {
        return NSHomeDirectory()
    }()
    
    lazy var cachePath = {
       return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    }()
    
    static let instance:Environment = {
        return Environment()
    }()
    
    func get() -> [String:Any]{
        var env = [String:Any]()
        env["platform"] = "iOS"
        env["screenWidth"] = screenWidth
        env["screenHeight"] = screenHeight
        env["homePath"] = homePath
        env["cachePath"] = cachePath
        return env
    }
}
