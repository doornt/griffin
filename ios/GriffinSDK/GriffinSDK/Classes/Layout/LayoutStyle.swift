//
//  Node.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/5.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation
import YogaKit

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
    
    static func zero() ->LayoutFrame{
        return LayoutFrame(x:0,y:0,width:0,height:0)
    }

}

class LayoutStyle{
    
    weak var _owner:ViewComponent!
    
    lazy var flex_direction:YGFlexDirection = .column
    
    var position:YGPositionType?
    
    var align_items:YGAlign?
    var justify_content:YGJustify?
    

    var margin_left:YGValue?
    var margin_top:YGValue?
    var margin_bottom:YGValue?
    var margin_right:YGValue?
    
    var width:YGValue?
    var height:YGValue?
    
    
    init(styles:Dictionary<String,Any>,owner:ViewComponent) {
        self._owner = owner
        
        if let direction = styles["flex-direction"] as? String{
            switch(direction){
            case "row":
                self.flex_direction = YGFlexDirection.row
                break
            case "column":
                self.flex_direction = YGFlexDirection.column
                break
                
            default:
                self.flex_direction = YGFlexDirection.column
            }
        }
        
        if let a_i = styles["align-items"] as? String{
            switch(a_i){
            case "center":
                    self.align_items = YGAlign.center
                break
            default:
                break
            }
        }
        
        if let j_t = styles["justify-content"] as? String{
            switch(j_t){
            case "center":
                self.justify_content = YGJustify.center
                break
            default:
                break
            }
        }
        
        if let w = Utils.any2CGFloat(styles["width"]){
            self.width = YGValue(w)
        }
        
        if let h =  Utils.any2CGFloat(styles["height"]){
            self.height = YGValue(h)
        }
        
        if let m_left = Utils.any2CGFloat(styles["margin-left"]){
            self.margin_left = YGValue(m_left)
        }
        
        if let m_top = Utils.any2CGFloat(styles["margin-top"]){
            self.margin_top = YGValue(m_top)
        }
        
        if let m_right = Utils.any2CGFloat(styles["margin-right"]){
            self.margin_right = YGValue(m_right)
        }
        
        if let m_bottom = Utils.any2CGFloat(styles["margin-bottom"]){
            self.margin_bottom = YGValue(m_bottom)
        }
        

    }
    
    
    func update(){
        
        let view:UIView = self._owner.loadView()
        view.configureLayout { (layout) in
//            layout.position = .absolute
            layout.flexDirection = self.flex_direction
            layout.isEnabled = true
            if self.width != nil {
                layout.width = self.width!
            }
            if self.height != nil{
                layout.height = self.height!
            }
            if self.align_items != nil{
                layout.alignItems = self.align_items!
            }
            if self.justify_content != nil{
                layout.justifyContent = self.justify_content!
            }
            if self.margin_left != nil{
                layout.marginLeft = self.margin_left!
            }
            if self.margin_top != nil{
                layout.marginTop = self.margin_top!
            }
            if self.margin_right != nil{
                layout.marginRight = self.margin_right!
            }
            if self.margin_bottom != nil{
                layout.marginBottom = self.margin_bottom!
            }
            
            layout.applyLayout(preservingOrigin: true)
        }
        
        
    }
    
    
}
