//
//  Node.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/5.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class LayoutStyle{
    
    weak var _owner:ViewComponent!

    private static let _layoutConifg:YGConfigRef = {
        let layoutConifg = YGConfigNew()
        YGConfigSetExperimentalFeatureEnabled(layoutConifg, YGExperimentalFeatureWebFlexBasis, true)
        YGConfigSetPointScaleFactor(layoutConifg, Environment.instance.screenScale)
        return layoutConifg!
    }()
    
    var _node:YGNodeRef!
    var node:YGNodeRef{
        return self._node
    }
    
    /**
     The property that decides if we should include this view when calculating layout. Defaults to YES.
     */
    var isIncludedInLayout:Bool = true
    
    /**
     The property that decides during layout/sizing whether or not styling properties should be applied.
     Defaults to NO.
     */
    var isEnabled:Bool?
    
    var alignSelf:YGAlign?
    var flexWrap:YGWrap?
    
    var flexShrink:CGFloat?
    var flexBasis:YGValue?
    
    var start:YGValue?
    var end:YGValue?
    
    var marginStart:YGValue?
    var marginEnd:YGValue?
    var marginHorizontal:YGValue?
    var marginVertical:YGValue?
    var margin:YGValue?
    
    var paddingLeft:YGValue?
    var paddingTop:YGValue?
    var paddingRight:YGValue?
    var paddingBottom:YGValue?
    var paddingStart:YGValue?
    var paddingEnd:YGValue?
    var paddingHorizontal:YGValue?
    var paddingVertical:YGValue?
    var padding:YGValue?
    
    var borderLeftWidth:CGFloat?
    var borderTopWidth:CGFloat?
    var borderRightWidth:CGFloat?
    var borderBottomWidth:CGFloat?
    var borderStartWidth:CGFloat?
    var borderEndWidth:CGFloat?
    var borderWidth:CGFloat?
    
    var minWidth:YGValue?
    
    var minHeight:YGValue?
    var maxWidth:YGValue?
    
    // Yoga specific properties, not compatible with flexbox specification
    var aspectRatio:CGFloat?
    
    /**
     Get the resolved direction of this node. This won't be YGDirectionInherit
     */
    var resolvedDirection:YGDirection?
    
    lazy var requestFrame:CGRect = CGRect.zero

    init(styles:Dictionary<String,Any>,owner:ViewComponent) {
        self._owner = owner
        self._node = YGNodeNewWithConfig(LayoutStyle._layoutConifg)
        YGNodeSetContext(self._node, unsafeBitCast(self._owner, to: UnsafeMutableRawPointer.self))
        
        self.display = YGDisplayFlex
        
        if let position = Utils.any2String(styles["position"]){
            switch(position){
            case "absolute":
                self.position = YGPositionTypeAbsolute
                break
            case "relative":
                self.position = YGPositionTypeRelative
                break
                
            default:
                self.position = YGPositionTypeRelative
            }
        }
        
        if let left = Utils.any2CGFloat(styles["left"]){
            self.left = YGValue(left)
        }
        
        if let top = Utils.any2CGFloat(styles["top"]){
            self.top = YGValue(top)
        }
        if let bottom = Utils.any2CGFloat(styles["bottom"]){
            self.bottom = YGValue(bottom)
        }
        
        if let right = Utils.any2CGFloat(styles["right"]){
            self.right = YGValue(right)
        }
        
        if let direction = styles["flex-direction"] as? String{
            switch(direction){
            case "row":
                self.flexDirection = YGFlexDirectionRow
                break
            case "column":
                self.flexDirection = YGFlexDirectionColumn
                break

            default:
                self.flexDirection = YGFlexDirectionColumn
            }
        }

        if let a_i = styles["align-items"] as? String{
            switch(a_i){
            case "center":
                    self.alignItems = YGAlignCenter
                break
            default:
                break
            }
        }

        if let j_t = styles["justify-content"] as? String{
            switch(j_t){
            case "center":
                self.justifyContent = YGJustifyCenter
                break
            case "space-between":
                self.justifyContent = YGJustifySpaceBetween
                break
            case "space-around":
                self.justifyContent = YGJustifySpaceAround
                break
            case "flex-start":
                self.justifyContent = YGJustifyFlexStart
                break
            default:
                break
            }
        }
        
        if let overflow = styles["overflow"] as? String{
            switch(overflow){
            case "scroll":
                self.overflow = YGOverflowScroll
                break
            default:
                break
            }
        }

        if let w = Utils.any2YGValue(styles["width"]){
            self.width = w
        }
        if let h =  Utils.any2YGValue(styles["height"]){
            self.height = h
        }
        if let max_h =  Utils.any2YGValue(styles["max-height"]){
            self.maxHeight = max_h
        }

        if let m_left = Utils.any2CGFloat(styles["margin-left"]){
            self.marginLeft = YGValue(m_left)
        }

        if let m_top = Utils.any2CGFloat(styles["margin-top"]){
            self.marginTop = YGValue(m_top)
        }

        if let m_right = Utils.any2CGFloat(styles["margin-right"]){
            self.marginRight = YGValue(m_right)
        }
        
        if let m_bottom = Utils.any2CGFloat(styles["margin-bottom"]){
            self.marginBottom = YGValue(m_bottom)
        }
        
        if let flex_grow = Utils.any2Float(styles["flex-grow"]){
            self.flexGrow = flex_grow
        }
    }
}
