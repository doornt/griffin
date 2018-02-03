//
//  WebSocket.swift
//  GriffinSDK
//
//  Created by sampson on 2018/2/3.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation


open class WebSocket :NSObject{
    
    convenience init(_ url:String) {
        self.init(request:URLRequest(url: URL(string: url)!))
    }
    
    init(request:URLRequest) {
        
    }
}
