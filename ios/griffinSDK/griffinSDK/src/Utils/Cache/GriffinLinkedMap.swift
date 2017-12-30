//
//  GriffinLinkedMap.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2017/12/30.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import Foundation

class LinkedMap {
    
    var dic: [AnyHashable: LinkedNode] = [AnyHashable: LinkedNode]()
    var totalCount: UInt = 0
    var totalCost: UInt = 0
    var head: LinkedNode?
    var tail: LinkedNode?
    var releaseOnMainThread: Bool = false
    var releaseAsynchronously: Bool = true
    
    func insertNodeAt(head node: LinkedNode) {
        dic[node.key] = node
        
        totalCost  += node.cost
        totalCount += 1
        
        if self.head != nil {
            node.next = self.head
            self.head?.prev = node
            self.head = node
        } else {
            self.head = node
            self.tail = node
        }
    }
    
    func bringNodeTo(head node: LinkedNode) {
        if head == nil {
            return
        }
        
        if (head! === node) {
            return
        }
        
        if (tail! === node) {
            tail = node.prev;
            tail?.next = nil;
        } else {
            node.next!.prev = node.prev
            node.prev!.next = node.next
        }
        node.next = head
        node.prev = nil
        head?.prev = node
        head = node
    }
    
    func remove(node: LinkedNode) {
        
        if head == nil {
            return
        }
        
        dic.removeValue(forKey: node.key)
        totalCost -= node.cost;
        totalCount -= 1;
        
        if node.next != nil {
            node.next!.prev = node.prev
        }
        if node.prev != nil {
            node.prev!.next = node.next
        }
        if head === node {
            head = node.next
            
        }
        if tail === node {
            tail = node.prev
        }
    }
    
    func removeTail() -> LinkedNode? {
        if tail == nil {
            return nil
        }
        
        dic.removeValue(forKey: tail!.key)
        totalCost -= tail!.cost;
        totalCount -= 1;
        
        if tail!.prev != nil {
            tail!.prev!.next = nil
        }
        if (head === tail) {
            head = nil
            tail = nil
        } else {
            tail = tail!.prev;
            tail!.next = nil;
        }
        return tail;
    }
    
    func removeAll() {
        totalCost = 0;
        totalCount = 0;
        head = nil;
        tail = nil;
        dic = [AnyHashable: LinkedNode]()
    }
}

class LinkedNode {
    var prev: LinkedNode?
    var next: LinkedNode?
    
    var cost: UInt = 0
    var time: TimeInterval?
    
    var key: AnyHashable
    var value: Any?
    
    init(key: AnyHashable) {
        self.key = key
    }
    
}
