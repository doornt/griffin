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
    
    static var errorCount = 0
    
    private init() {
        startFetchJSFile(isFirst: "1")
    }
    
    private func startFetchJSFile(isFirst: String) {
        let urlString = "http://127.0.0.1:8081/"
        NetworkManager.instance.get(url: urlString, params: ["isFirst": isFirst], completionHandler: {
            [weak self] (data, error) in
            guard let data = data as? [String: String] else {
                DebugManager.errorCount += 1
                if (DebugManager.errorCount > 3) {
                    return
                }
                self?.startFetchJSFile(isFirst: "0")
                return
            }
            
        
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FileChanged"), object: nil, userInfo: ["script": data["data"]!])
            
            DebugManager.errorCount = 0
            self?.startFetchJSFile(isFirst: "0")
        })
    }
    
    public func logToServer() {
        let urlString = "http://127.0.0.1:8081/log"
        NetworkManager.instance.post(url: urlString, params: ["isFirst": "isfor"], completionHandler: {
            (data, error) in
        })
    }
}
