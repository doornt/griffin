//
//  GriffinCache.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2017/12/29.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import Foundation

class GriffinCache {
    
    var name: String?
    var memCache: GriffinMemoryCache?
    var diskCache: GriffinDiskCache?
    
    init(name: String) {
        self.name = name
        
        let cachePath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let fullPath = cachePath + "/com.doornt." + name
        
        cacheWith(path: fullPath)
    }
    
    func contains(for key: String) -> Bool {
        guard let memCache = self.memCache, let diskCache = self.diskCache else {
            return false
        }
        return memCache.contains(for: key) || diskCache.contains(for: key)
    }
    
    func contains(for key: String, completion: ((String, Bool) -> Void)?) {
        guard let memCache = self.memCache, let diskCache = self.diskCache, let completion = completion else {
            return
        }
        
        if memCache.contains(for: key) {
            DispatchQueue.global(qos: .default).async {
                completion(key, true)
            }
        } else {
            diskCache.contains(for: key, completion: completion)
        }
    }
    
    func object(for key: String) -> Any? {
        guard let memCache = self.memCache, let diskCache = self.diskCache else {
            return nil
        }
        var obj = memCache.object(for:key)
        if obj != nil {
            return obj
        }
        
        obj = diskCache.object(for: key)
        
        if obj != nil {
            memCache.setObject(obj, for: key)
        }
        return obj
    }
    
    func object(for key:String, completion: @escaping (String, Any?) -> Void) {
        guard let memCache = self.memCache, let diskCache = self.diskCache else {
            return
        }
        
        let obj = memCache.object(for:key)
        if obj != nil {
            DispatchQueue.global(qos: .default).async {
                completion(key, obj)
            }
        } else {
            diskCache.object(for: key, completion: { (key, data) in
                if (data != nil) && (memCache.object(for: key) == nil) {
                    memCache.setObject(data, for: key)
                }
                completion(key, data)
            })
        }
    }
    
    func setObject(_ object: Any?, for key: String) {
        guard let memCache = self.memCache, let diskCache = self.diskCache else {
            return
        }
        memCache.setObject(object, for: key)
        diskCache.setObject(object, for: key)
    }
    
    func setObject(_ object: Any?, for key:String, completion: (() -> Void)?) {
        guard let memCache = self.memCache, let diskCache = self.diskCache else {
            return
        }
        DispatchQueue.global(qos: .default).async {
            memCache.setObject(object, for: key)
        }
        diskCache.setObject(object, for: key, completion: completion)
    }
    
    func removeObject(for key: String) {
        guard let memCache = self.memCache, let diskCache = self.diskCache else {
            return
        }
        memCache.removeObject(for: key)
        diskCache.removeObject(for: key)
    }
    
    func removeObject(for key: String, completion: ((String) -> Void)?) {
        guard let memCache = self.memCache, let diskCache = self.diskCache else {
            return
        }
        DispatchQueue.global(qos: .default).async {
            memCache.removeObject(for: key)
        }
        
        diskCache.removeObject(for: key, completion: completion)
    }
    
    func removeAllObject() {
        guard let memCache = self.memCache, let diskCache = self.diskCache else {
            return
        }
        memCache.removeAllObjects()
        diskCache.removeAllObjects()
    }
    
    func removeAllObjects(with completion:(() -> Void)?) {
        guard let memCache = self.memCache, let diskCache = self.diskCache else {
            return
        }
        DispatchQueue.global(qos: .default).async {
            memCache.removeAllObjects()
        }
        diskCache.removeAllObjects(with: completion)
    }
    
    func removeAllObjects(with processHandler: ((Int, Int) ->Void)?, completion: ((Bool)->Void)?) {
        guard let memCache = self.memCache, let diskCache = self.diskCache else {
            return
        }
        DispatchQueue.global(qos: .default).async {
            memCache.removeAllObjects()
        }
        diskCache.removeAllObjects(with: processHandler, completion: completion)
    }
}

extension GriffinCache {
    private func cacheWith(path: String) {
        if path.count <= 0 {
            return
        }
        
        let tmpDiskCache = GriffinDiskCache.init(path: path)
        guard let diskCache = tmpDiskCache else {
            return
        }
        self.diskCache = diskCache
        
        let tmpMemCache = GriffinMemoryCache()
        guard let memCache = tmpMemCache else {
            return
        }
        memCache.name = NSString(string: path).lastPathComponent
        self.memCache = memCache
    }
}
