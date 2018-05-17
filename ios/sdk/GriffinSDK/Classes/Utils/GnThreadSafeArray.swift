//
//  GnThreadSafeArray.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/2/26.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

var _SafeArrayHashId = 0

class GnThreadSafeArray<Value> {
    
    private var _array:[Value] = [Value]()
    private var _queue:DispatchQueue
    
    init() {
        _queue = DispatchQueue(label: "com.doornt.griffin.array_\(_SafeArrayHashId)", attributes: .concurrent)
        _SafeArrayHashId += 1
    }
    
    var count: Int {
        var tmpCount: Int = 0
        _queue.sync {
            tmpCount = _array.count
        }
        return tmpCount
    }
    
    var last: Value? {
        var lastValue: Value? = nil
        _queue.sync {
            lastValue = _array.last
        }
        return lastValue
    }
    
    var first: Value? {
        var firstValue: Value? = nil
        _queue.sync {
            firstValue = _array.first
        }
        return firstValue
    }
    
    func removeAll() {
        __dispatch_barrier_async(_queue) {
            self._array.removeAll()
        }
    }
    
    func append(_ value: Value) {
        __dispatch_barrier_async(_queue) {
            self._array.append(value)
        }
    }
    
    func removeLast() {
        __dispatch_barrier_async(_queue) {
            self._array.removeLast()
        }
    }
}
