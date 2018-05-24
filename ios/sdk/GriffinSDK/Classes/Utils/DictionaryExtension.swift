//
//  DictionaryExtension.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/21.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation
import JavaScriptCore

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
    
    func toJSValue(key:String)->JSValue?{
        return self[key] as? JSValue
    }
    
    func toArray(key: String) -> Array<Any>? {
        return self[key] as? Array
    }
    
    func toJsonString() -> String? {
        if !JSONSerialization.isValidJSONObject(self) {
            return nil
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return nil
        }
        return String.init(data: data, encoding: .utf8)
    }
}
