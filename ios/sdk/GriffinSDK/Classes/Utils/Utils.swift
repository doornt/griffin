//
//  Utils.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2017/12/22.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

class Utils {
    
    class func any2YGValue(_ obj: Any?) -> YGValue? {
        if let fObj = Utils.any2CGFloat(obj){
            return YGValue(fObj)
        }
        if var sObj = obj as? String {
            var unit = YGUnitUndefined
            if sObj.last == "%" {
                unit = YGUnitPercent
                sObj.remove(at: sObj.index(before: sObj.endIndex))
            }
            
            if let f = Float(sObj) {
                return YGValue(value: f, unit: unit)
            }
            
        }
        return nil
    }
    
    class func any2Int(_ obj: Any?) -> Int? {
        return obj as? Int
    }
    
    class func any2CGFloat(_ obj: Any?) -> CGFloat? {
        return obj as? CGFloat
    }
    
    class func any2Float(_ obj: Any?) -> Float? {
        return obj as? Float
    }
    
    class func any2String(_ obj: Any?) -> String? {
        return obj as? String
    }
    
    class func any2Array(_ obj: Any?) -> Array<Any> {
        return obj as? Array ?? []
    }
    
    class func any2Bool(_ obj: Any?) -> Bool? {
        return obj as? Bool
    }
    
    class func hexString2UIColor(_ hex:String?) -> UIColor? {
        guard let hex = hex else {
            return nil
        }
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return nil
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}


