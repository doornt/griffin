//
//  DebugManager.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/1/25.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation


class DebugManager {
    
    let ws = WebSocket("ws://127.0.0.1:8081")
    
    static let instance: DebugManager = {
       return DebugManager()
    }()
    
    static var errorCount = 0
    
    private init() {
        ws.onNativeMessage = {
            [weak self] data in
            if (Utils.any2String(data) != nil) &&  Utils.any2String(data)! == "onchange" {
                self?.startFetchJSFile(isFirst: "0")
            }
        }
        startFetchJSFile(isFirst: "1")
    }
    
    private func startFetchJSFile(isFirst: String) {
        let urlString = "http://127.0.0.1:8081/dist/bundle.js"
        
        if isFirst == "0" {
            print("reload view")
        }
        
        NetworkManager.instance.downloadFile(url: urlString, completionHandler: {
            (data) in
          
            guard let data = data else{
                return
            }
            
            let str = String.init(data: data, encoding: String.Encoding.utf8)
            
        
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FileChanged"), object: nil, userInfo: ["script": str ?? ""])
            
        })
    }
}
