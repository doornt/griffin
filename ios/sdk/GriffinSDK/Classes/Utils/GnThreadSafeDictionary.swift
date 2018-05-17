//
//  GnThreadSafeDictionary.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/2/26.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

var _SafeDictionaryHashId = 0

class GnThreadSafeDictionary<Key, Value> where Key:Hashable {
    
    private var _dict:[Key:Value] = [Key:Value]()
    private var _queue:DispatchQueue
    
    init() {
        _queue = DispatchQueue(label: "com.doornt.griffin.dictionary_\(_SafeDictionaryHashId)", attributes: .concurrent)
        _SafeDictionaryHashId += 1
    }
    
    var count: Int {
        var tmpCount: Int = 0
        _queue.sync {
            tmpCount = _dict.count
        }
        return tmpCount
    }
    
    subscript(key: Key) -> Value? {
        get {
            var obj:Value? = nil
            _queue.sync {
                obj = _dict[key]
            }
            return obj
        }
        set {
            __dispatch_barrier_async(_queue) {
                self._dict[key] = newValue
            }
        }
    }
    
    var values: [Value] {
        var obj: [Value] = [Value]()
        _queue.sync {
            obj = Array(_dict.values)
        }
        return obj
    }
    
    func removeValue(forKey key: Key) -> Value? {
        var removed: Value? = nil
        __dispatch_barrier_sync(_queue) {
            removed = _dict[key]
            _dict[key] = nil
        }
        return removed
    }
    
    func removeValue(forKeys keys: Array<Key>) -> [Value?] {
        var removed = [Value?]()
        __dispatch_barrier_sync(_queue) {
            for key in keys {
                removed.append(_dict[key])
                _dict[key] = nil
            }
        }
        return removed
    }
    
    func removeValueAsync(forKey key: Key) {
            self[key] = nil
    }
    
    func removeValueAsync(forKeys keys: Array<Key>) {
        __dispatch_barrier_async(_queue) {
            for key in keys {
                self[key] = nil
            }
        }
    }
    
    func allKeys() -> [Key] {
        var keys: [Key] = [Key]()
        _queue.sync {
            for item in _dict {
                keys.append(item.key)
            }
        }
        return keys
    }
}
