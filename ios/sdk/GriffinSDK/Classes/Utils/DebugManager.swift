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
        let urlString = "http://127.0.0.1:8081/bundle.js"
        
        if isFirst == "0"{
            print("reload view")
        }
        
        NetworkManager.instance.downloadFile(url: urlString, completionHandler: {
            [weak self] (data) in
          
            guard let data = data else{
                return
            }
            
            let str = String.init(data: data, encoding: String.Encoding.utf8)
            
        
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FileChanged"), object: nil, userInfo: ["script": str])
            
        })
    }
    
    public func logToServer() {
        JSCoreBridge.instance.performOnJSThread {
            JSCoreBridge.instance.register(method: {
                [weak self] in
                self?.startFetchJSFile(isFirst: "0")
            } as @convention(block)()-> Void , script: "reloadView")
        }
    }
}
