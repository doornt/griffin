//
//  Node.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/5.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

//struct position {
//    var left:Float = 0
//    var top:Float = 0
//    var right:Float = 0
//    var bottom:Float = 0
//
//}

struct LayoutFrame{
    var x:CGFloat = 0
    var y:CGFloat = 0
    var width:CGFloat = 0
    var height:CGFloat = 0

}

class LayoutStyle{
    
    var _owner:ViewComponent
    
    var isDirty:Bool = true
    
    lazy var flex_direction:flex_direction = .column
    
    var align_items:align_items?
    var justify_content:justify_content?
    
    var _last_frame:LayoutFrame = LayoutFrame(x: 0, y: 0, width: 0, height: 0)
    var _layout_frame:LayoutFrame = LayoutFrame(x: 0, y: 0, width: 0, height: 0)

    var style_margin_left:CGFloat = 0
    var style_margin_top:CGFloat = 0
    var style_margin_bottom:CGFloat = 0
    var style_margin_right:CGFloat = 0
    
    
    init(styles:Dictionary<String,Any>,owner:ViewComponent) {
        self._owner = owner
        self._layout_frame.width = Utils.any2CGFloat(styles["width"]) ?? 0
        self._layout_frame.height = Utils.any2CGFloat(styles["height"]) ?? 0
        self.style_margin_left = Utils.any2CGFloat(styles["margin-left"]) ?? 0
        self.style_margin_top = Utils.any2CGFloat(styles["margin-top"]) ?? 0
        self.style_margin_bottom = Utils.any2CGFloat(styles["margin-bottom"]) ?? 0
        self.style_margin_right = Utils.any2CGFloat(styles["margin-right"]) ?? 0

    }
    
    var children: Array<LayoutStyle>{
        var arry:[LayoutStyle] = []
        for child in self._owner.children{
            arry.append(child.layout)
        }
        return arry
    }
    
    var parent:LayoutStyle?{
        return self._owner._parent?.layout
    }
    
    func update(){
        
        // 后面做diff
        let needRefresh = true
        
        if needRefresh{
            self.beginLayout()
            self._owner.layoutFinish()
        }
        
        
    }
    
    func beginLayout(){
        
        var directionDistance:CGFloat = 0
        
        for child in self.children{
            if flex_direction == .column{
                child._layout_frame.y += directionDistance + child.style_margin_top
                child._layout_frame.x = child.style_margin_left
                directionDistance = child._layout_frame.y + child._layout_frame.height + child.style_margin_bottom
            }else{
                child._layout_frame.x += directionDistance + child.style_margin_left
                child._layout_frame.y = self.style_margin_top
                directionDistance = child._layout_frame.x +  child._layout_frame.width + child.style_margin_right
            }
            child.update()
        }
    }
    
    
}
