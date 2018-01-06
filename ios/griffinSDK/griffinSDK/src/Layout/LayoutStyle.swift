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

    var style_margin_left:Float = 0
    var style_margin_top:Float = 0
    var style_margin_bottom:Float = 0
    var style_margin_right:Float = 0
    
    
    init(styles:Dictionary<String,Any>,owner:ViewComponent) {
        self._owner = owner
        self._layout_frame.width = Utils.any2CGFloat(styles["width"]) ?? 0
        self._layout_frame.height = Utils.any2CGFloat(styles["height"]) ?? 0
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
        guard let parent = self.parent else {
            return
        }
        
        // 后面做diff
        let needRefresh = true
        
        if needRefresh{
            self.beginLayout(parent)
        }
        
        
    }
    
    func beginLayout(_ parent:LayoutStyle){
        for child in self.children{
            if flex_direction == .column{
                
            }
            
            child.update()
        }
    }
    
    
}
