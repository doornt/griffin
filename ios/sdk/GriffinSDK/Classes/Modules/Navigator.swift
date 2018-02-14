//
//  Navigator.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/2/11.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol NavigatorProtocol: JSExport {
    func push(_ id:String, _ animated: Bool, _ callback: JSValue)
    func pop(_ animated: Bool, _ callback: JSValue)
}

class Navigator:NSObject, NavigatorProtocol {
    
    func push(_ id: String, _ animated: Bool, _ callback: JSValue) {
        DispatchQueue.main.async {
            RootComponentManager.instance.pushViewController(withId: id, animated: animated)
        }
    }
    
    func pop(_ animated: Bool, _ callback: JSValue) {
        DispatchQueue.main.async {
            print(animated)
            RootComponentManager.instance.popViewController(animated: animated)
        }
    }
}
