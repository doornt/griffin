//
//  GriffinDiskCache.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2017/12/29.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import Foundation

class GriffinDiskCache {
    
    init?(path: String) {
        
    }
    
    func contains(for key: String) -> Bool {
        return false
    }
    func contains(for key: String, completion: (String, Bool) -> Void) {
        
    }
    func object(for key: String) -> Any? {
        return nil
    }
    func object(for key:String, completion: (String, Any?) -> Void) {
        
    }
    
    func setObject(_ object: Any?, for key: String) {
        
    }
    func setObject(_ object: Any?, for key:String, completion: (() -> Void)?) {
        
    }
    func removeObject(for key: String) {

    }
    func removeObject(for key: String, completion: ((String) -> Void)?) {
    }
    func removeAllObjects() {
        
    }
    func removeAllObjects(with completion:(() -> Void)?) {
        
    }
    
    func removeAllObjects(with processHandler: ((Int, Int) ->Void)?, completion: ((Bool)->Void)?) {
        
    }
}
