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
    
    private var _id: UInt = 0
    
    init() {
        _id = generateHostId()
    }
}

extension ControllerHost {
    
    func destroy() {
        
    }
    
    func dispatchVCLifeCycle2Js(_ period: String) {
        
    }
    
//    private func dispatchVCLifeCycle2Js(period: String) {
//        //        JSCoreBridge.instance.dispatchEventToJs(rootviewId: rootView?.instanceId ?? "", data: ["type": period])
//    }
}
extension ControllerHost {
    private func generateHostId() -> UInt {
        struct Holder {
            static var id: UInt = 0
        }
        Holder.id += 1
        return Holder.id
    }
}
