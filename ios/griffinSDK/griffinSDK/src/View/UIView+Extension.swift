//
//  UIView+Extension.swift
//  GriffinSDK
//
//  Created by sjtupt on 2017/12/26.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import Foundation
import JavaScriptCore

private var eventKey: Void?
private var lifeCycleKey: Void?
private var instanceIdKey: Void?

protocol ViewProtocol {
    func update(_ dict:Dictionary<String,Any>)
}

// MARK: - Associate Object
extension UIView {
    var instanceId: String? {
        get {
            guard let value = objc_getAssociatedObject(self, &instanceIdKey) as? String else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &instanceIdKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var lifeCycleDict: Dictionary<String, JSValue>? {
        get {
            guard let value = objc_getAssociatedObject(self, &lifeCycleKey) as? Dictionary<String, JSValue> else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &lifeCycleKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var events: Dictionary<String, Array<JSValue>>? {
        get {
            guard let value = objc_getAssociatedObject(self, &eventKey) as? Dictionary<String, Array<JSValue>> else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &eventKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - Gesture
extension UIView {
    
    func addTapGesture() {
        self.isUserInteractionEnabled = true
        // add tap gensture
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    func removeTapGesuture() {
        self.isUserInteractionEnabled = false
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let events = self.events, let clicks = events["click"] else {
            return
        }
        for click in clicks {
            click.callWithoutArguments()
        }
    }
}

// MARK: - registerEvent & unRegisterEvent
extension UIView {
    
    func register(event: String, callBack: JSValue) {
        if self.events == nil {
            self.events = Dictionary()
        }
        
        if self.events![event] == nil {
            var array: [JSValue] = Array()
            array.append(callBack)
            self.events![event] = array
        } else {
            var array = self.events![event]
            array?.append(callBack)
        }
        
        if event == "click" {
            addTapGesture()
        }
    }
    
    func unRegister(event: String, callBack: JSValue) {
        guard var eventDic = self.events,
            let eventArr = eventDic[event] else {
                return
        }
        eventDic[event] = eventArr.filter { $0 != callBack }
        self.events = eventDic
        
        if event == "click" {
            removeTapGesuture()
        }
    }
}
