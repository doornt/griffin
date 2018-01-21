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
    
    /**
     The property that decides if we should include this view when calculating layout. Defaults to YES.
     */
    var isIncludedInLayout:Bool = true
    
    /**
     The property that decides during layout/sizing whether or not styling properties should be applied.
     Defaults to NO.
     */
    var isEnabled:Bool?
    
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
    
    var alignSelf:YGAlign?
    var position:YGPositionType?
    var flexWrap:YGWrap?
    var overflow:YGOverflow?
    var display:YGDisplay?
    
    var flexGrow:CGFloat?
    var flexShrink:CGFloat?
    var flexBasis:YGValue?
    
    var left:YGValue?
    var top:YGValue?
    var right:YGValue?
    var bottom:YGValue?
    var start:YGValue?
    var end:YGValue?
    
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
    
    var width:YGValue{
        get{
            return YGNodeStyleGetWidth(self.node)
        }
        set{
            YGNodeStyleSetWidth(self.node, newValue.value)
        }
    }
    var height:YGValue{
        get{
            return YGNodeStyleGetHeight(self.node)
        }
        set{
            YGNodeStyleSetHeight(self.node, newValue.value)
        }
    }
    
    var minWidth:YGValue?
    
    var minHeight:YGValue?
    var maxWidth:YGValue?
    var maxHeight:YGValue?
    
    // Yoga specific properties, not compatible with flexbox specification
    var aspectRatio:CGFloat?
    
    /**
     Get the resolved direction of this node. This won't be YGDirectionInherit
     */
    var resolvedDirection:YGDirection?
    
    lazy var requestFrame:CGRect = CGRect.zero
    
    var node:YGNodeRef{
        return self._node
    }
    

    
    init(styles:Dictionary<String,Any>,owner:ViewComponent) {
        self._owner = owner
        self._node = YGNodeNewWithConfig(LayoutStyle._layoutConifg)
        
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
        
        self.update()
        
        
    }
    
    
    func update(){
        self.applyLayoutPreservingOrigin(preserveOrigin: true)
        YGNodePrint(node,YGPrintOptions(rawValue: YGPrintOptions.RawValue(UInt8(YGPrintOptionsLayout.rawValue)|UInt8(YGPrintOptionsStyle.rawValue)|UInt8(YGPrintOptionsChildren.rawValue))))
    }
    
    var isLeaf:Bool{
        let len = self._owner.childrenLayouts.count
        if len == 0{
            return true
        }
        return false
    }
    
//    static let YGMeasureView: @convention(c) (Optional<OpaquePointer>, Float, YGMeasureMode,Float, YGMeasureMode ) -> YGSize = {
//
//        (node, width, widthMode, height, heightMode) in
//        let constrainedWidth = (widthMode == YGMeasureModeUndefined) ?
//            Float.greatestFiniteMagnitude : width
//        let constrainedHeight = (heightMode == YGMeasureModeUndefined) ? Float.greatestFiniteMagnitude: height
//
//        //        UIView *view = (__bridge UIView*) YGNodeGetContext(node);
//        //        const CGSize sizeThatFits = [view sizeThatFits:(CGSize) {
//        //        .width = constrainedWidth,
//        //        .height = constrainedHeight,
//        //        }];
//        //
//
//        return YGSize(width: Float(LayoutStyle.YGSanitizeMeasurement(CGFloat(constrainedWidth), CGFloat(constrainedWidth),widthMode)), height: Float(LayoutStyle.YGSanitizeMeasurement(CGFloat(constrainedHeight), CGFloat(constrainedHeight), heightMode)))
//    }
    
    
    func calculateLayoutWithSize(_ width:Float,_ height:Float)->CGSize{
    
        LayoutStyle.YGAttachNodesFromViewHierachy(self);
        
        YGNodeCalculateLayout(
        self.node,
        width,
        height,
        YGNodeStyleGetDirection(node));
        
        return CGSize(width: CGFloat(YGNodeLayoutGetWidth(node)), height: CGFloat(YGNodeLayoutGetHeight(node)))
        
    }
    
    func applyLayoutPreservingOrigin(preserveOrigin:Bool){
        let _ = self.calculateLayoutWithSize(self.width.value,self.height.value)
        LayoutStyle.YGApplyLayoutToViewHierarchy(self, preserveOrigin);
    }
    
    static func YGRemoveAllChildren(_ node:YGNodeRef){
    
        while (YGNodeGetChildCount(node) > 0) {
            YGNodeRemoveChild(node, YGNodeGetChild(node, YGNodeGetChildCount(node) - 1));
        }
    }
    
    static func YGNodeHasExactSameChildren(_ node:YGNodeRef, _ children:[LayoutStyle])->Bool{
        if (YGNodeGetChildCount(node) != children.count) {
            return false
        }
        
        for (i ,child) in children.enumerated() {
            if YGNodeGetChild(node, UInt32(i)) != child.node{
                return false
            }
        }
        
        return true
    }
    
    
    static func YGAttachNodesFromViewHierachy(_ layout:LayoutStyle){
        let node = layout.node
    
        // Only leaf nodes should have a measure function
        if (layout.isLeaf) {
            LayoutStyle.YGRemoveAllChildren(node);
//            YGNodeSetMeasureFunc(node, LayoutStyle.YGMeasureView);
        } else {
            YGNodeSetMeasureFunc(node, nil);
            var subviewsToInclude:[LayoutStyle] = []
        
            for child in layout._owner.childrenLayouts{
                if child.isIncludedInLayout{
                    subviewsToInclude.append(child)
                }
            }
    
            if (!YGNodeHasExactSameChildren(node, subviewsToInclude)) {
                YGRemoveAllChildren(node);

                for (index,child) in subviewsToInclude.enumerated(){
                    YGNodeInsertChild(node, child.node, UInt32(index))
                }

            }

            for child in subviewsToInclude{
                YGAttachNodesFromViewHierachy(child)
            }

        }
    }
    
//    static func YGSanitizeMeasurement(_ constrainedSize:CGFloat,_ measuredSize:CGFloat,
//                               _ measureMode:YGMeasureMode)->CGFloat{
//        var result:CGFloat
//        if (measureMode == YGMeasureModeExactly) {
//            result = constrainedSize
//        } else if (measureMode == YGMeasureModeAtMost) {
//            result = min(constrainedSize, measuredSize)
//        } else {
//            result = measuredSize;
//        }
//        return result
//    }
    
    static func YGApplyLayoutToViewHierarchy(_ layout:LayoutStyle,_ preserveOrigin:Bool)
    {
        let node:YGNodeRef  = layout.node;

        let left = YGNodeLayoutGetLeft(node)
        let top = YGNodeLayoutGetTop(node)
        let width = YGNodeLayoutGetWidth(node)
        let height = YGNodeLayoutGetHeight(node)

        layout.requestFrame = CGRect(x: CGFloat(left), y: CGFloat(top), width: CGFloat(width), height: CGFloat(height))
        
        if !layout.isLeaf {
            for child in layout._owner.childrenLayouts{
                LayoutStyle.YGApplyLayoutToViewHierarchy(child,false)
            }
        }
    }
    
}
