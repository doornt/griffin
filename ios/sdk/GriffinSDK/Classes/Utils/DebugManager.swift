//
//  DebugManager.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/1/25.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation


class DebugManager {
    
    static let instance: DebugManager = {
       return DebugManager()
    }()
    
    private init() {
        startFetchJSFile()
    }
    
    private func startFetchJSFile() {
        let urlString = "http://127.0.0.1:8081/"
        NetworkManager.instance.get(url: urlString, params: nil, completionHandler: {
            [weak self] (data, error) in
            guard let data = data as? [String: String] else {
                return
            }
            
            let _ = JSCoreBridge.instance.executeJavascript(script: data["data"]!)
            self?.startFetchJSFile()
        })
    }
}
