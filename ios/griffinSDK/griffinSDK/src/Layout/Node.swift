//
//  Node.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/5.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class LayoutNode{
    
    var _owner:UIView
    
    init(styles:Dictionary<String,Any>,owner:UIView) {
        self._owner = owner
        
    }
    
    var children: Array<LayoutNode>{
        var arry:[LayoutNode] = []
        for child in self._owner.subviews{
            
        }
        return children
    }
    
    
}
