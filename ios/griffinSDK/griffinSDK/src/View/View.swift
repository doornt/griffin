//
//  View.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/21.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit
import JavaScriptCore

private var eventKey: Void?
private var lifeCycleKey: Void?
private var instanceIdKey: Void?

protocol ViewProtocol {
    
    func updateView(dict:Dictionary<String,Any>)
}

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
    
    func config(dict:Dictionary<String,Any>){
        
        let w:CGFloat = Utils.any2CGFloat(obj: dict["width"]) ?? 0
        let h:CGFloat = Utils.any2CGFloat(obj: dict["height"]) ?? 0
        let y:CGFloat = Utils.any2CGFloat(obj: dict["top"]) ?? 0
        let x:CGFloat = Utils.any2CGFloat(obj: dict["left"]) ?? 0
        self.frame = CGRect(x: x, y: y, width: w, height: h)
        
        if Utils.hexString2UIColor(hex: Utils.any2String(obj: dict["backgroundColor"])) != nil {
            self.backgroundColor = Utils.hexString2UIColor(hex: Utils.any2String(obj: dict["backgroundColor"]))
        }
        
        self.clipsToBounds = Utils.any2Bool(obj: dict["overflow"]) ?? false
        self.alpha = Utils.any2CGFloat(obj: dict["opacity"]) ?? 1.0
        
        self.layer.borderWidth = Utils.any2CGFloat(obj: dict["borderWidth"]) ?? 0
        
        if Utils.hexString2UIColor(hex: Utils.any2String(obj: dict["borderColor"])) != nil {
            self.layer.borderColor = Utils.hexString2UIColor(hex: Utils.any2String(obj: dict["borderColor"]))!.cgColor
        }

        self.layer.cornerRadius = Utils.any2CGFloat(obj: dict["cornerRadius"]) ?? 0
    
        for view in subviews {
            view.removeFromSuperview()
        }
        
        for child in Utils.any2Array(obj: dict["children"]) {
            let rChild = child as? Dictionary<String, Any>
            guard let realChild = rChild else {
                continue
            }
            let childView: View = View(dict: realChild)
            addSubview(childView)
        }
    }
    
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
    
    public func registerEvent(_ event: String, callBack: JSValue) {
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
    
    public func unRegisterEvent(_ event: String, callBack: JSValue) {
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

public class View :UIView, ViewProtocol {

    public var id:String?
    
    convenience init(dict:Dictionary<String,Any>){
        self.init()
        self.id = dict["class"] as? String

        self.isUserInteractionEnabled = false
        config(dict: dict)
    }
    
    func updateView(dict: Dictionary<String, Any>) {
        config(dict: dict)
    }
}

public class Label :UILabel, ViewProtocol {
    convenience init(dict:Dictionary<String,Any>){
        self.init()
        self.isUserInteractionEnabled = false
        buildLabel(dict: dict)
    }
    
    func buildLabel(dict:Dictionary<String,Any>) {
        
        config(dict: dict)
        
        self.text = Utils.any2String(obj: dict["text"])
        
        if Utils.hexString2UIColor(hex: Utils.any2String(obj: dict["textColor"])) != nil {
            self.textColor = Utils.hexString2UIColor(hex: Utils.any2String(obj: dict["textColor"]))
        }
        
        if self.layer.cornerRadius > 0 {
            self.layer.masksToBounds = true
        }
        self.sizeToFit()
    }
    
    func updateView(dict: Dictionary<String, Any>) {
        buildLabel(dict: dict)
    }
}

public class ImageView :UIImageView, ViewProtocol {
    convenience init(dict:Dictionary<String,Any>){
        self.init()
        self.isUserInteractionEnabled = false
        buildImageView(dict: dict)
    }
    
    func buildImageView(dict:Dictionary<String,Any>) {
        
        config(dict: dict)
        
        let url = URL.init(string: Utils.any2String(obj: dict["url"]) ?? "" )
        guard let rUrl = url,
              let data = try? Data.init(contentsOf: rUrl)  else {
            return
        }
        self.image = UIImage.init(data: data, scale: UIScreen.main.scale)
        
        if self.layer.cornerRadius > 0 {
            self.layer.masksToBounds = true
        }
    }
    
    func updateView(dict: Dictionary<String, Any>) {
        buildImageView(dict: dict)
    }
}

