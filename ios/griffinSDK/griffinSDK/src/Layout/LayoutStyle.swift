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
    
    var style_width:Float = 0
    var style_height:Float = 0
    
    var style_left:Float = 0
    var style_top:Float = 0
    var style_right:Float?
    var style_bottom:Float?
    
    var style_margin_left:Float = 0
    var style_margin_top:Float = 0
    var style_margin_bottom:Float = 0
    var style_margin_right:Float = 0
    
    var layout_left:Float = 0
    var layout_top:Float = 0
    var layout_right:Float?
    var layout_bottom:Float?

    
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
    
    func update(){
        
    }
    
    
}
