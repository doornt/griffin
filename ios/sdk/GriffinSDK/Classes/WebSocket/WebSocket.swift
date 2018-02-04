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
    var onmessage : (_ data : Any)->(){get set}
}

@objc open class WebSocket :NSObject,WebSocketProtocol{
    
    fileprivate var ws: InnerWebSocket
    fileprivate var opened: Bool = true

    
    public required init(_ url:String) {
        ws = InnerWebSocket(request: URLRequest(url: URL(string: url)!))
        super.init()

        self.onmessage = {
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
    
    var onmessage : (_ data : Any)->(){
        get{
            return ws.event.message
        }
        set{
            ws.event.message = newValue
        }
    }

}
