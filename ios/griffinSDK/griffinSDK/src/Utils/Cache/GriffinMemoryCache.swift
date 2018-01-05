//
//  GriffinMemoryCache.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2017/12/29.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import Foundation

class GriffinMemoryCache {
    
    var name: String?

    private var countLimit = UInt.max
    private var costLimit = UInt.max
    private var ageLimit: TimeInterval = Double.greatestFiniteMagnitude
    private var autoTrimInterval: TimeInterval = 5.0
    
    private var shouldRemoveAllObjectsOnMemoryWarning: Bool = true
    private var shouldRemoveAllObjectsWhenEnteringBackground: Bool = true
    
    private var didReceiveMemoryWarningBlock: ((GriffinMemoryCache)->Void)?
    private var didEnterBackgroundBlock: ((GriffinMemoryCache)->Void)?
    
    private var lock: pthread_mutex_t = pthread_mutex_t()
    private let lru = LinkedMap()
    private let queue = DispatchQueue.init(label: "com.dornt.cache.memory")
    
    init?() {
    
        pthread_mutex_init(&lock, nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidReceiveMemoryWarningNotification), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackgroundNotification), name: .UIApplicationDidEnterBackground, object: nil)
        
        trimRecursively()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        lru.removeAll()
        pthread_mutex_destroy(&lock)
    }
    
    func contains(for key: AnyHashable) -> Bool {
        pthread_mutex_lock(&lock)
        let result = lru.dic[key] != nil
        pthread_mutex_unlock(&lock)
        return result
    }
    
    func object(for key: AnyHashable) -> Any? {
        
        pthread_mutex_lock(&lock)
        let node = lru.dic[key]
        if node != nil {
            node!.time = Date().timeIntervalSince1970
            lru.bringNodeTo(head: node!)
        }
        pthread_mutex_unlock(&lock)
        
        if node != nil {
            return node!.value
        } else {
            return nil
        }
    }
    
    func setObject(_ object: Any?, for key: AnyHashable) {
        setObject(object, for: key, cost: 0)
    }
    
    func setObject(_ object: Any?, for key: AnyHashable, cost: UInt) {
        guard let object = object else {
            self.removeObject(for: key)
            return
        }
        pthread_mutex_lock(&lock)
    
        let node = lru.dic[key]
        
        if node != nil {
            node!.time = Date().timeIntervalSince1970
            node!.value = object
            node!.cost = cost
            lru.totalCount -= node!.cost
            lru.totalCost += cost
            
            lru.bringNodeTo(head: node!)
        } else {
            let linkedNode = LinkedNode(key: key)
            linkedNode.value = object
            linkedNode.key = key
            linkedNode.cost = cost
            linkedNode.time = Date().timeIntervalSince1970
            lru.insertNodeAt(head: linkedNode)
        }
        
        if (lru.totalCount > countLimit) {
            let node = lru.removeTail()
            if (lru.releaseAsynchronously) {
                let queue = lru.releaseOnMainThread ? DispatchQueue.main : DispatchQueue.global(qos: .utility)
                queue.async {
                    if node != nil {
                        let _ = node?.cost
                    }
                }
            } else if (lru.releaseOnMainThread && pthread_main_np() == 0) {
                DispatchQueue.main.async {
                    if node != nil {
                        let _ = node?.cost
                    }
                }
            }
        }
        pthread_mutex_unlock(&lock)
    }
    
    func removeObject(for key: AnyHashable) {
        pthread_mutex_lock(&lock);
        let node = lru.dic[key]
        if node != nil {
            lru.remove(node: node!)
            if (lru.releaseAsynchronously) {
                let queue = lru.releaseOnMainThread ? DispatchQueue.main : DispatchQueue.global(qos: .utility)
                queue.async {
                    let _ = node!.cost
                }
            } else if (lru.releaseOnMainThread && pthread_main_np() == 0) {
                DispatchQueue.main.async {
                    let _ = node!.cost
                }
            }
        }
        pthread_mutex_unlock(&lock);
    }
    
    func removeAllObjects() {
        pthread_mutex_lock(&lock)
        lru.removeAll()
        pthread_mutex_unlock(&lock)
    }
    
    func removeAllObjects(with completion:(() -> Void)?) {
        removeAllObjects()
    }
    
    func trimToCount(_ count: UInt) {
        if count == 0 {
            removeAllObjects()
            return;
        }
        _trimToCount(count)
    }
    func trimToCost(_ cost: UInt) {
        _trimToCost(cost)
    }
    func trimToAge(_ age: TimeInterval) {
        _trimToAge(age)
    }
}

private extension GriffinMemoryCache {
    func trimRecursively() {
        
        let delay = DispatchTime.now() + autoTrimInterval
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: delay) {
            [weak self] in
            if self == nil {
                return
            }
            self!.trimInBackground()
            self!.trimRecursively()
        }
    }
    
    func trimInBackground() {
        queue.async {
            [weak self] in
            if self == nil {
                return
            }
            self!._trimToAge(self!.ageLimit)
            self!._trimToCount(self!.countLimit)
            self!._trimToCost(self!.costLimit)
        }
    }
    
    func _trimToCount(_ count: UInt) {
        var finish = false
        pthread_mutex_lock(&lock)
        if count == 0 {
            lru.removeAll()
            finish = true
        } else if count >= lru.totalCount {
            finish = true
        }
        pthread_mutex_unlock(&lock)
        if finish {
            return
        }
        
        var holder: [LinkedNode] = [LinkedNode]()
        while !finish {
            
            if pthread_mutex_trylock(&lock) == 0 {
                
                if count < lru.totalCount {
                    
                    let node = lru.removeTail()
                    if node != nil {
                        holder.append(node!)
                    }
                } else {
                    finish = true
                }
                
                pthread_mutex_unlock(&lock)
            } else {
                usleep(10 * 1000)
            }
 
        }
        
        if holder.count > 0 {
            let queue = lru.releaseOnMainThread ? DispatchQueue.main :
                DispatchQueue.global(qos: .utility)
            queue.async {
                let _ = holder.count
            }
        }
    }
    
    func _trimToCost(_ cost: UInt) {
        
        var finish = false
        pthread_mutex_lock(&lock)
        if cost == 0 {
            lru.removeAll()
            finish = true
        } else if cost >= lru.totalCost {
            finish = true
        }
        pthread_mutex_unlock(&lock)
        if finish {
            return
        }
        
        var holder: [LinkedNode] = [LinkedNode]()
        while !finish {
            
            if pthread_mutex_trylock(&lock) == 0 {
                
                if cost < lru.totalCost {
                    
                    let node = lru.removeTail()
                    if node != nil {
                        holder.append(node!)
                    }
                } else {
                    finish = true
                }
                
                pthread_mutex_unlock(&lock)
            } else {
                usleep(10 * 1000)
            }
            
        }
        
        if holder.count > 0 {
            let queue = lru.releaseOnMainThread ? DispatchQueue.main :
                DispatchQueue.global(qos: .utility)
            queue.async {
                let _ = holder.count
            }
        }
        
    }
    
    func _trimToAge(_ age: TimeInterval) {
        var finish = false
        
        let now = Date().timeIntervalSince1970
        
        pthread_mutex_lock(&lock)
        if age <= 0 {
            lru.removeAll()
            finish = true
        } else if (lru.tail != nil && (now - (lru.tail?.time)!) <= Double(age)) {
            finish = true
        }
        pthread_mutex_unlock(&lock)
        if finish {
            return
        }
        
        var holder: [LinkedNode] = [LinkedNode]()
        while !finish {
            
            if pthread_mutex_trylock(&lock) == 0 {
                
                if lru.tail != nil && (now - (lru.tail?.time)!) <= Double(age) {
                    
                    let node = lru.removeTail()
                    if node != nil {
                        holder.append(node!)
                    }
                } else {
                    finish = true
                }
                
                pthread_mutex_unlock(&lock)
            } else {
                usleep(10 * 1000)
            }
            
        }
        
        if holder.count > 0 {
            let queue = lru.releaseOnMainThread ? DispatchQueue.main :
                DispatchQueue.global(qos: .utility)
            queue.async {
                let _ = holder.count
            }
        }
    }
    
    
}

private extension GriffinMemoryCache {
    var releaseOnMainThread: Bool {
        get {
            pthread_mutex_lock(&lock)
            let result = lru.releaseOnMainThread
            pthread_mutex_unlock(&lock)
            return result
        }
        set {
            pthread_mutex_lock(&lock)
            lru.releaseOnMainThread = newValue
            pthread_mutex_unlock(&lock)
        }
    }
    var releaseAsynchronously: Bool {
        get {
            pthread_mutex_lock(&lock)
            let result = lru.releaseAsynchronously
            pthread_mutex_unlock(&lock)
            return result
        }
        set {
            pthread_mutex_lock(&lock)
            lru.releaseAsynchronously = newValue
            pthread_mutex_unlock(&lock)
        }
    }
    
    var totalCount: UInt {
        get {
            pthread_mutex_lock(&lock)
            let totalCount = lru.totalCount
            pthread_mutex_unlock(&lock)
            return totalCount
        }
    }
    
    var totalCost: UInt {
        get {
            pthread_mutex_lock(&lock)
            let totalCost = lru.totalCost;
            pthread_mutex_unlock(&lock)
            return totalCost
        }
    }
    
}

extension GriffinMemoryCache {
    @objc func appDidReceiveMemoryWarningNotification() {
        if didReceiveMemoryWarningBlock != nil {
            didReceiveMemoryWarningBlock!(self)
        }
        
        if shouldRemoveAllObjectsOnMemoryWarning {
            removeAllObjects()
        }
    }
    
    @objc func appDidEnterBackgroundNotification() {
        if didEnterBackgroundBlock != nil {
            didEnterBackgroundBlock!(self)
        }
        
        if shouldRemoveAllObjectsWhenEnteringBackground {
            removeAllObjects()
        }
    }
}
