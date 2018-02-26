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
}


//        - (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
//{
//    aKey = [aKey copyWithZone:NULL];
//    dispatch_barrier_async(_queue, ^{
//        _dict[aKey] = anObject;
//        });
//    }
//
//    - (void)removeObjectForKey:(id)aKey
//{
//    dispatch_barrier_async(_queue, ^{
//        [_dict removeObjectForKey:aKey];
//        });
//    }
//
//    - (void)removeAllObjects{
//        dispatch_barrier_async(_queue, ^{
//            [_dict removeAllObjects];
//            });
//        }
//
//        - (id)copy{
//            __block id copyInstance;
//            dispatch_sync(_queue, ^{
//                copyInstance = [_dict copy];
//                });
//            return copyInstance;
//}
