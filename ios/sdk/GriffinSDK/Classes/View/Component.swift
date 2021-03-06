//
//  Component.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/5.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation
import JavaScriptCore
import UIKit

class ViewComponent {
    
    private lazy var _children: [ViewComponent] = []
    
    var rootViewId: String?
    
    var _parent:ViewComponent?
    
    private lazy var _viewLoaded = false
    
//    private var _view:UIView?
    
    var _layout:LayoutStyle?
    
    private var _ref:String
    
    var ref: String {
        get {
            return _ref
        }
    }
    
    private var _events:Dictionary<String, Array<JSValue>> = Dictionary<String, Array<JSValue>>()
    
    private var _backgroundColor:String?
    private var _alpha: CGFloat?
    
    private var _clickable: Bool = false
    
    private var _styles:Dictionary<String,Any> = [:]

    var ignoreLayout: Bool = false
    
    var _needsLayout:Bool = true
    private var _props:Dictionary<String,Any> = [:]
    
    required init(ref:String,styles:Dictionary<String,Any>,props:Dictionary<String,Any>) {
        self._ref = ref
        
        self.styles = styles
        
        self.updateProps(props)
        
        self.initLayoutWithStyles(styles: styles)
        
        GnThreadPool.instance.performOnMainThread {
            self.viewDidLoad()
        }
    }
    
    var styles:Dictionary<String,Any> {
        set{
            _styles = newValue
            if let bg = newValue.toString(key: "background-color"){
                self._backgroundColor = bg
            }
            
            if let alpha = newValue.toCGFloat(key: "opacity"){
                self._alpha = alpha
                self._needsLayout = true
            }
            
            
        }
        get{
            return [:]
        }

    }
    
    func updateProps(_ props:Dictionary<String,Any>){
        _props = props
        
        if let clickable = props.toBool(key: "clickable") {
            self._clickable = clickable
        }
    }

    
    func updateWithStyle(_ styles: Dictionary<String,Any>) {
        self.styles = styles
    }
    

    var view: UIView {
        preconditionFailure("loadView method must be overridden")
    }
    
    func refresh() {
        GnThreadPool.instance.performOnMainThread {
            
        }
    }
    
    func viewDidLoad() {
        assert(Thread.current == Thread.main, "setupView must be called in main thread")
        
        if _backgroundColor != nil{
            self.view.backgroundColor = Utils.hexString2UIColor(_backgroundColor)
        }
        
        if _clickable {
            self.addTapGesture()
        }
    }
    
    func addChild(_ child:ViewComponent){
        
        child.parent = self
        self._children.append(child)
        self._needsLayout = true
        RootComponentManager.instance.registerAddedComponent(child)
        
        GnThreadPool.instance.performOnMainThread {
            let superView = self.view
            let subView = child.view
            
            superView.addSubview(subView)
        }
    }
    
    func addChildren(_ children: [ViewComponent?]) {

        for c in children {
            if let component = c {
                component.parent = self
                self._children.append(component)
                RootComponentManager.instance.registerAddedComponent(component)
            }
        }
        self._needsLayout = true
        
        GnThreadPool.instance.performOnMainThread {
            
            let superView = self.view
            
            for c in children {
                if let component = c {
                    let subView = component.view
                    superView.addSubview(subView)
                }
            }
        }
    }
    
    func layoutFinish(){
        GnThreadPool.AssertMainThread(msg: "layoutFinish")
        let view:UIView = self.view
        if !self.ignoreLayout {
            view.frame = self.layout.requestFrame
        }
        self._needsLayout = false
    }
}

// MARK: - Component Operation
extension ViewComponent {
    func addChildAt(_ child:ViewComponent,_ index:Int){
        
    }
    
    func removeChild(_ child:ViewComponent){
        
    }
    
    func removeChildren(){
        RootComponentManager.instance.unregisterAddedComponents(_children)
        
        _children.removeAll()
        
        self._needsLayout = true

        GnThreadPool.instance.performOnMainThread {
            for view in self.view.subviews {
                view.removeFromSuperview()
            }
        }
    }
}

// MARK: - Caluate Property
extension ViewComponent {
    var children:[ViewComponent] {
        get {
            return self._children
        }
        set {
            self._children = newValue
        }
    }
    
    var parent:ViewComponent?{
        get{
            return self._parent
        }
        set{
            self._parent = newValue
        }
    }
}

// MARK: -Register Event
extension ViewComponent {
    func register(event: String, callBack: JSValue) {
        Log.Info("register \(event), withCallBack: \(callBack)")
        
        if self._events[event] == nil {
            var array: [JSValue] = Array()
            array.append(callBack)
            self._events[event] = array
        } else {
            var array = self._events[event]
            array?.append(callBack)
        }
        
        if event == "click" {
            DispatchQueue.main.async {
                self.addTapGesture()
            }
        }
    }
    
    func unRegister(event: String, callBack: JSValue) {
        Log.Info("unRegister \(event), withCallBack: \(callBack)")
        
        guard let eventArr = self._events[event] else {
            return
        }
        self._events[event] = eventArr.filter { $0 != callBack }
        
        if event == "click" {
            DispatchQueue.main.async {
                self.removeTapGesuture()
            }
        }
    }
}

// MARK: - Gesture
extension ViewComponent {
    
    func addTapGesture() {
        
        self.view.isUserInteractionEnabled = true
        // add tap gensture
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)

    }
    
    func removeTapGesuture() {
        self.view.isUserInteractionEnabled = false
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let rootViewId = self.rootViewId else {
            Log.Error("handleTap while self.rootviewid == nil")
            return
        }
        GnDispatchCenter.instance.dispatchEventToJs(rootviewId: rootViewId, data:  ["nodeId":self.ref, "event": "click"])
    }
}
