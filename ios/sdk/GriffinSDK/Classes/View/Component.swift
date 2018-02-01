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
    
    lazy private var _children: [ViewComponent] = []
    
    var _parent:ViewComponent?
    
    private lazy var _viewLoaded = false
    
    private var _view:UIView?
    
    var _layout:LayoutStyle?
    
    private var ref:String
    private var _events:Dictionary<String, Array<JSValue>> = Dictionary<String, Array<JSValue>>()
    
    private var _backgroundColor:String?
    private var _alpha: CGFloat?

    
    private var _styles:Dictionary<String,Any> = [:]
    
    var _needsLayout:Bool = true
    
    required init(ref:String,styles:Dictionary<String,Any>) {
        self.ref = ref
        
        self.styles = styles
        
        self.initLayoutWithStyles(styles: styles)
    }
    
    var styles:Dictionary<String,Any>{
        set{
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

    
    func updateWithStyle(_ styles: Dictionary<String,Any>) {
        self.styles = styles
    }
    

    func loadView() -> UIView {
        preconditionFailure("loadView method must be overridden")
    }
    
    func refresh() {
        assert(Thread.current == Thread.main, "refresh must be called in main thread")
        setupView()
    }
    
    func viewDidLoad() {}
    
    private func setupView() {
        assert(Thread.current == Thread.main, "setupView must be called in main thread")
        
        self._view = loadView()
        
        if _backgroundColor != nil{
            self._view?.backgroundColor = Utils.hexString2UIColor(_backgroundColor)
        }
   
        
//        self._view?.clipsToBounds = _isOverflow
//        self._view?.alpha = _alpha
        
//        self._view?.layer.borderWidth = _borderWidth
        
//        if Utils.hexString2UIColor(_borderColor) != nil {
//            self._view?.layer.borderColor = Utils.hexString2UIColor(_borderColor)!.cgColor
//        }
        
//        self._view?.layer.cornerRadius = _cornerRadius
        
        self.viewDidLoad()
    }
}

// MARK: - Component Operation
extension ViewComponent {
    func addChild(_ child:ViewComponent){
        
        assert(Thread.current == Thread.main, "addChild must be called in main thread")
        
        let superView = self.view
        let subView = child.view
        
        superView.addSubview(subView)
        
        child.parent = self
        self._children.append(child)
        self._needsLayout = true
    }
    
    func addChildAt(_ child:ViewComponent,_ index:Int){
        
    }
    
    func removeChild(_ child:ViewComponent){
        
    }
    
    func removeChildren(){
        
    }
}

// MARK: - Caluate Property

extension ViewComponent {
    var children:[ViewComponent]{
        return self._children
    }
    
    var view: UIView {
        assert(Thread.current == Thread.main, "get view must be called in main thread")
        if self._view != nil {
            return self._view!
        }
        setupView()
        return self._view!
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
        Log.LogInfo("register \(event), withCallBack: \(callBack)")
        
        if self._events[event] == nil {
            var array: [JSValue] = Array()
            array.append(callBack)
            self._events[event] = array
        } else {
            var array = self._events[event]
            array?.append(callBack)
        }
        
        if event == "click" {
            addTapGesture()
        }
    }
    
    func unRegister(event: String, callBack: JSValue) {
        Log.LogInfo("unRegister \(event), withCallBack: \(callBack)")
        
        guard let eventArr = self._events[event] else {
            return
        }
        self._events[event] = eventArr.filter { $0 != callBack }
        
        if event == "click" {
            removeTapGesuture()
        }
    }
}

// MARK: - Gesture
extension ViewComponent {
    
    func addTapGesture() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            // add tap gensture
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            self.view.addGestureRecognizer(tap)
        }
    }
    
    func removeTapGesuture() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let clicks = self._events["click"] else {
            return
        }
        for click in clicks {
            click.callWithoutArguments()
        }
    }
}
