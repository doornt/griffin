//
//  NetworkManager.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2017/12/28.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let instance: NetworkManager = {
        return NetworkManager()
    }()
    
    func downloadFile(url:String ,completionHandler:@escaping (Data?)->Void){
        guard let url = URL(string: url) else {
            return
        }
        
        let mutableReq = NSMutableURLRequest.init(url: url)
        mutableReq.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: mutableReq as URLRequest) { (data, response, error) in
            
            if let error = error {
                completionHandler(nil)
                return
            }
            
            guard let data = data else {
                return
            }
            
            
            completionHandler(data)
        }
        
        task.resume()
        
    }
    
    func get(url: String, params: [String: String]?, completionHandler: ((Any?, Error?) -> Void)? ) -> Void {

        guard let url = URL(string: url) else {
            return
        }
        
        let mutableReq = NSMutableURLRequest.init(url: url)
        mutableReq.httpMethod = "GET"
    
        var formatString = "&%@"
        if mutableReq.url?.query == nil {
            formatString = "?%@"
        }
        
        let paramsString = getStringFromat(with: params)
        
        mutableReq.url = URL(string: (mutableReq.url?.absoluteString.appendingFormat(formatString, paramsString))!)
        
        let task = URLSession.shared.dataTask(with: mutableReq as URLRequest) { (data, response, error) in
            
            if let error = error {
                completionHandler?(nil, error)
                return
            }
            
            guard let data = data else {
                return
            }
            
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
            
            completionHandler?(jsonData, nil)
        }
        
        task.resume()
    }
    
    func post(url: String, params: [String: String]?, completionHandler: ((Any?, Error?) -> Void)?) -> Void {
        guard let url = URL(string: url) else {
            return
        }
        
        let mutableReq = NSMutableURLRequest.init(url: url)
        mutableReq.httpMethod = "POST"
        
        if params != nil {
            mutableReq.httpBody =  params!.toJsonString()?.data(using: String.Encoding.utf8)
        }
        
        mutableReq.url = url
        
        let task = URLSession.shared.dataTask(with: mutableReq as URLRequest) { (data, response, error) in
            
            if let error = error {
                completionHandler?(nil, error)
                return
            }
            
            guard let data = data else {
                return
            }
            
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
            
            completionHandler?(jsonData, nil)
        }
        
        task.resume()
        
    }
}

private extension NetworkManager {
    
    func getStringFromat(with params: [String: String]?) -> String {
        guard let params = params else {
            return ""
        }
        
        var result = String()
        for (key, value) in params {
            result += key + "=" + value + "&"
        }
        
        return result
    }
    
}
