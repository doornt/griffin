//
//  Environment.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2017/12/23.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

class Environment {
    
    lazy var screenSize: CGSize = {
        var size = UIScreen.main.bounds.size
        if UIDevice.current.model !=  "iPad" {
            size = CGSize.init(width: min(size.width, size.height), height: max(size.width, size.height))
        }
        return size
    }()
    
    var screenWidth: CGFloat {
        return screenSize.width
    }
    var screenHeight: CGFloat {
        return screenSize.height
    }
    
    let screenScale = Float(UIScreen.main.scale)
    
    lazy var homePath = {
        return NSHomeDirectory()
    }()
    
    lazy var cachePath = {
       return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    }()
    
    static let instance:Environment = {
        return Environment()
    }()
    
    var assetsUrl: String {
        #if DEBUG
            return "http://127.0.0.1:8081/"
        #else
            return ""
        #endif
        
    }
    func get() -> [String:Any]{
        var env = [String:Any]()
        env["platform"] = "iOS"
        env["screenWidth"] = screenWidth
        env["screenHeight"] = screenHeight
        env["homePath"] = homePath
        env["cachePath"] = cachePath
        
        env["assetsUrl"] = self.assetsUrl
        return env
    }
}
