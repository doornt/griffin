//
//  DictionaryExtension.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/21.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

extension Dictionary where Key == String {
    
    func toFloat(key:String)->Float?{
       return self[key] as? Float
    }
    
    func toCGFloat(key:String)->CGFloat?{
        return self[key] as? CGFloat
    }

    func toString(key:String)->String?{
        return self[key] as? String
    }
    
    func toBool(key:String)->Bool?{
        return self[key] as? Bool
    }
}
