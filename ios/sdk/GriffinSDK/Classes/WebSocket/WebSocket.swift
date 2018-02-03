//
//  WebSocket.swift
//  GriffinSDK
//
//  Created by sampson on 2018/2/3.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation


open class WebSocket :NSObject{
    
    fileprivate var ws: InnerWebSocket
    fileprivate var opened: Bool

    
    public convenience init(_ url:String) {
        self.init(request:URLRequest(url: URL(string: url)!))
    }
    
    init(request:URLRequest) {
        let hasURL = request.url != nil
        opened = hasURL
        ws = InnerWebSocket(request: request)
        ws.event.message = self.onmessage
    }
    
    open func send(_ message : Any){
        if !opened{
            return
        }
        ws.send(message)
    }
    
    var onmessage : (_ data : Any)->() = {(data) in
        print(data)
    }

}
