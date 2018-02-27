//
//  LayoutStyleComputedProperty.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/2/27.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

extension LayoutStyle {
    var position: YGPositionType {
        get {
            return YGNodeStyleGetPositionType(self.node);
        }
        set {
            YGNodeStyleSetPositionType(self.node, newValue);
        }
    }
    
    var direction:YGDirection{
        get{
            return YGNodeStyleGetDirection(self.node)
        }
        set{
            YGNodeStyleSetDirection(self.node, newValue)
        }
    }
    var flexDirection:YGFlexDirection{
        get{
            return YGNodeStyleGetFlexDirection(self.node)
        }
        set{
            YGNodeStyleSetFlexDirection(self.node, newValue)
        }
    }
    
    var justifyContent:YGJustify{
        get{
            return YGNodeStyleGetJustifyContent(self.node)
        }
        set{
            YGNodeStyleSetJustifyContent(self.node, newValue)
        }
    }
    
    var alignContent:YGAlign{
        get{
            return YGNodeStyleGetAlignContent(self.node)
        }
        set{
            YGNodeStyleSetAlignContent(self.node, newValue)
        }
    }
    
    var alignItems:YGAlign{
        get{
            return YGNodeStyleGetAlignItems(self.node)
        }
        set{
            YGNodeStyleSetAlignItems(self.node, newValue)
        }
    }
    
//    var alignSelf:YGAlign?
//    var flexWrap:YGWrap?
    var overflow:YGOverflow {
        get {
            return YGNodeStyleGetOverflow(self.node)
        }
        set {
            YGNodeStyleSetOverflow(self.node, newValue)
        }
    }
    
    var display:YGDisplay{
        get{
            return YGNodeStyleGetDisplay(self.node)
        }
        set{
            YGNodeStyleSetDisplay(self.node, newValue)
        }
    }
    
    var flexGrow:Float{
        get{
            return YGNodeStyleGetFlexGrow(self.node)
        }
        set{
            YGNodeStyleSetFlexGrow(self.node, newValue)
        }
    }
//    var flexShrink:CGFloat?
//    var flexBasis:YGValue?
    
    var left:YGValue {
        get {
            return YGNodeStyleGetPosition(self.node, YGEdgeLeft)
        }
        set {
            YGNodeStyleSetPosition(self.node, YGEdgeLeft, newValue.value)
        }
    }
    var top:YGValue {
        get {
            return YGNodeStyleGetPosition(self.node, YGEdgeTop)
        }
        set {
            YGNodeStyleSetPosition(self.node,YGEdgeTop, newValue.value)
        }
    }
    var right:YGValue {
        get {
            return YGNodeStyleGetPosition(self.node, YGEdgeRight)
        }
        set {
            YGNodeStyleSetPosition(self.node, YGEdgeRight, newValue.value)
        }
    }
    var bottom:YGValue {
        get {
            return YGNodeStyleGetPosition(self.node, YGEdgeBottom)
        }
        set {
            YGNodeStyleSetPosition(self.node, YGEdgeBottom, newValue.value)
        }
    }
//    var start:YGValue?
//    var end:YGValue?
    
    var marginLeft:YGValue{
        get{
            return YGNodeStyleGetMargin(self.node, YGEdgeLeft)
        }
        set{
            YGNodeStyleSetMargin(self.node, YGEdgeLeft, newValue.value)
        }
    }
    var marginTop:YGValue{
        get{
            return YGNodeStyleGetMargin(self.node, YGEdgeTop)
        }
        set{
            YGNodeStyleSetMargin(self.node, YGEdgeTop, newValue.value)
        }
    }
    var marginRight:YGValue{
        get{
            return YGNodeStyleGetMargin(self.node, YGEdgeRight)
        }
        set{
            YGNodeStyleSetMargin(self.node, YGEdgeRight, newValue.value)
        }
    }
    var marginBottom:YGValue{
        get{
            return YGNodeStyleGetMargin(self.node, YGEdgeBottom)
        }
        set{
            YGNodeStyleSetMargin(self.node, YGEdgeBottom, newValue.value)
        }
    }
    
//    var marginStart:YGValue?
//    var marginEnd:YGValue?
//    var marginHorizontal:YGValue?
//    var marginVertical:YGValue?
//    var margin:YGValue?
//
//    var paddingLeft:YGValue?
//    var paddingTop:YGValue?
//    var paddingRight:YGValue?
//    var paddingBottom:YGValue?
//    var paddingStart:YGValue?
//    var paddingEnd:YGValue?
//    var paddingHorizontal:YGValue?
//    var paddingVertical:YGValue?
//    var padding:YGValue?
//
//    var borderLeftWidth:CGFloat?
//    var borderTopWidth:CGFloat?
//    var borderRightWidth:CGFloat?
//    var borderBottomWidth:CGFloat?
//    var borderStartWidth:CGFloat?
//    var borderEndWidth:CGFloat?
//    var borderWidth:CGFloat?
    
    var width:YGValue{
        get{
            return YGNodeStyleGetWidth(self.node)
        }
        set{
            switch newValue.unit {
            case YGUnitPoint:
                YGNodeStyleSetWidth(self.node, newValue.value)
                break
            case YGUnitPercent:
                YGNodeStyleSetWidthPercent(self.node, newValue.value)
                break
            case YGUnitAuto:
                YGNodeStyleSetWidthAuto(self.node)
                break
            default:
                assert(false, "Not implemented")
            }
        }
    }
    var height:YGValue{
        get{
            return YGNodeStyleGetHeight(self.node)
        }
        set{
            switch newValue.unit {
            case YGUnitPoint:
                YGNodeStyleSetHeight(self.node, newValue.value)
                break
            case YGUnitPercent:
                YGNodeStyleSetHeightPercent(self.node, newValue.value)
                break
            case YGUnitAuto:
                YGNodeStyleSetHeightAuto(self.node)
                break
            default:
                assert(false, "Not implemented")
            }
        }
    }
    
//    var minWidth:YGValue?
//
//    var minHeight:YGValue?
    var maxHeight:YGValue{
        get{
            return YGNodeStyleGetMaxHeight(self.node)
        }
        set{
            switch newValue.unit {
            case YGUnitPoint:
                YGNodeStyleSetMaxHeight(self.node, newValue.value)
                break
            case YGUnitPercent:
                YGNodeStyleSetMaxHeightPercent(self.node, newValue.value)
                break
            default:
                assert(false, "Not implemented")
            }
        }
    }
//    var maxWidth:YGValue?
}
