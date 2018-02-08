//
//  ControllerHost.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/2/6.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class ControllerHost {
    
    private weak var _vc: UIViewController?
    var vc: UIViewController? {
        get {
           return _vc
        }
        set {
            _vc = newValue
        }
    }
    
    private var _pageName: String?
    var pageName: String? {
        get {
            return _pageName
        }
        set {
            _pageName = newValue
        }
    }
    
    private var _onCreate: ((UIView) -> Void)?
    var onCreate:((UIView) -> Void)? {
        get {
            return _onCreate
        }
        set {
            _onCreate = newValue
        }
    }
    
    private var _onFailed: ((Error) -> Void)?
    var onFailed: ((Error) -> Void)? {
        get {
            return _onFailed
        }
        set {
            _onFailed = newValue
        }
    }
    
    private var _onRenderFinish: ((UIView) -> Void)?
    var onRenderFinish:((UIView) -> Void)? {
        get {
            return _onRenderFinish
        }
        set {
            _onRenderFinish = newValue
        }
    }
    
    private var _rootView:UIView?
    var rootView: UIView? {
        get {
            return _rootView
        }
        set {
            _rootView = newValue
        }
    }
    private var _frame: CGRect?
    var frame: CGRect? {
        get {
            return _frame ?? CGRect.init(x: 0, y: 0, width: Environment.instance.screenWidth, height: Environment.instance.screenHeight)
        }
        set {
            _frame = newValue
        }
    }
    
    private var _id: String = ""
    
    init() {
        _id = generateHostId()
        GnManager.instance.saveControllerHost(host: self, forId: _id)
        
    }
}

extension ControllerHost {
    
    func renderWithURL(urlString: String) {
        
        DispatchQueue.main.async {
            self._rootView = UIView.init(frame: self.frame!)
            if (self.onCreate != nil) {
                self.onCreate!(self._rootView!)
            }
        }
        
        NetworkManager.instance.downloadFile(url: urlString) {
            [weak self] (data) in
            
            guard let data = data else {
                return
            }
            
            ComponentManager.instance.controllerHost = self;
            
            JSCoreBridge.instance.performOnJSThread {
                JSCoreBridge.instance.executeJavascript(script:String.init(data: data, encoding: String.Encoding.utf8)!)
            }
        }
    }
    
    func destroy() {
        
        GnManager.instance.removeControllerHost(forId: self._id)
        ComponentManager.instance.unload()
    }
    
    func dispatchVCLifeCycle2Js(_ period: String) {
        
    }
    
//    private func dispatchVCLifeCycle2Js(period: String) {
//        //        JSCoreBridge.instance.dispatchEventToJs(rootviewId: rootView?.instanceId ?? "", data: ["type": period])
//    }
}
extension ControllerHost {
    private func generateHostId() -> String {
        struct Holder {
            static var id: UInt = 0
        }
        Holder.id += 1
        return String(Holder.id)
    }
}
