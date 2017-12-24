//
//  Environment.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2017/12/23.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

public class Environment: NSObject {
    public let screenWidth  = UIScreen.main.bounds.size.width
    public let screenHeight = UIScreen.main.bounds.size.height
    
    public static let instance:Environment = {
        return Environment()
    }()
}
