//
//  Node.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/5.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class LayoutStyle{
    
    var _owner:ViewComponent
    
    var isDirty:Bool = true
    
    lazy var flex_direction:flex_direction = .column
    
    var align_items:align_items?
    var justify_content:justify_content?
    
    var width:Float = 0
    var height:Float = 0
    
    var left:Float = 0
    var top:Float = 0
    var right:Float?
    var bottom:Float?
    
    init(styles:Dictionary<String,Any>,owner:ViewComponent) {
        self._owner = owner
    }
    
    var children: Array<LayoutStyle>{
        var arry:[LayoutStyle] = []
        for child in self._owner.children{
            arry.append(child.layout!)
        }
        return arry
    }
    
    var parent:LayoutStyle?{
        return self._owner._parent?.layout
    }
    
    
}
