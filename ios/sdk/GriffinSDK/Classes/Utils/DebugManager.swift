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
        startFetchJSFile(isFirst: "1")
    }
    
    private func startFetchJSFile(isFirst: String) {
        let urlString = "http://127.0.0.1:8081/"
        NetworkManager.instance.get(url: urlString, params: ["isFirst": isFirst], completionHandler: {
            [weak self] (data, error) in
            guard let data = data as? [String: String] else {
                self?.startFetchJSFile(isFirst: "0")
                return
            }
            
        
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FileChanged"), object: nil, userInfo: ["script": data["data"]!])
            
            self?.startFetchJSFile(isFirst: "0")
        })
    }
}
