//
//  GnManager.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/2/8.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class GnManager {
    
    static let instance = GnManager()
    
    private var controllerHostDic: [String: ControllerHost] = [:]
    
    private init() {}
    
}

extension GnManager {
    func controllerHost(forId: String) -> ControllerHost? {
        return GnManager.instance.controllerHostDic[forId]
    }
    func saveControllerHost(host: ControllerHost, forId: String) {
        GnManager.instance.controllerHostDic[forId] = host
    }
    func removeControllerHost(forId: String) {
        GnManager.instance.controllerHostDic.removeValue(forKey: forId)
    }
}
