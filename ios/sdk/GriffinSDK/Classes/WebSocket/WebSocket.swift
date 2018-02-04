//
//  WebSocket.swift
//  GriffinSDK
//
//  Created by sampson on 2018/2/3.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

import JavaScriptCore

@objc protocol WebSocketProtocol : JSExport {
    func send(_ message : Any)
    var onmessage : JSValue? {get set}
    
}

@objc open class WebSocket :NSObject,WebSocketProtocol{
    
    
    
    fileprivate var ws: InnerWebSocket
    fileprivate var opened: Bool = true
    fileprivate var _onmessage:JSValue?

    
    public required init(_ url:String) {
        ws = InnerWebSocket(request: URLRequest(url: URL(string: url)!))
        super.init()

        ws.event.message = {
            data in
            print(data)
        }
        
    }
  
    
    open func send(_ message : Any){
        if !opened{
            return
        }
        ws.send(message)
    }
    
    var onmessage : JSValue?{
        get{
            return self._onmessage
        }
        set{
            if newValue != nil{
                ws.event.message = {
                    data in
                    newValue!.call(withArguments: [data])
                }
            }
            self._onmessage = newValue
        }
    }

}
