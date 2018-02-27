//
//  LayoutStyleCore.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/2/27.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

extension LayoutStyle {
    
    var isLeaf:Bool{
        let len = self._owner.childrenLayouts.count
        if len == 0{
            return true
        }
        return false
    }
    
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
        
        //        print("yoga log begin")
        //        YGNodePrint(node,YGPrintOptions(rawValue: YGPrintOptions.RawValue(UInt8(YGPrintOptionsLayout.rawValue)|UInt8(YGPrintOptionsStyle.rawValue)|UInt8(YGPrintOptionsChildren.rawValue))))
        //        print("\nyoga log end")
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
    
    static func YGSanitizeMeasurement(_ constrainedSize:CGFloat,_ measuredSize:CGFloat,
                                      _ measureMode:YGMeasureMode)->CGFloat{
        var result:CGFloat
        if (measureMode == YGMeasureModeExactly) {
            result = constrainedSize
        } else if (measureMode == YGMeasureModeAtMost) {
            result = min(constrainedSize, measuredSize)
        } else {
            result = measuredSize;
        }
        return result
    }
    
    static let YGMeasureView:@convention(c) (Optional<OpaquePointer>,Float,YGMeasureMode,Float,YGMeasureMode) -> YGSize = {
        (node, width,widthMode,height,heightMode) -> YGSize in
        
        let constrainedWidth = (widthMode == YGMeasureModeUndefined) ?  Float.greatestFiniteMagnitude: width
        var constrainedHeight = (heightMode == YGMeasureModeUndefined) ? Float.greatestFiniteMagnitude: height
        
        let owner = YGNodeGetContext(node)
        
        let label: Label = unsafeBitCast(owner, to: Label.self)
        
        let dic = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: label.fontSize ?? 20)]
        
        
        let rect:CGSize = label.text.boundingRect(with: CGSize.init(width: CGFloat(constrainedWidth), height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dic, context: nil).size
        
        //        print("jjjj", widthMode, heightMode,label.text, rect, constrainedWidth, constrainedHeight)
        
        return YGSize.init(width: Float(YGSanitizeMeasurement(CGFloat(constrainedWidth), rect.width, widthMode)), height: Float(YGSanitizeMeasurement(CGFloat(constrainedHeight), rect.height, heightMode)))
        
    }
    
    static func YGAttachNodesFromViewHierachy(_ layout:LayoutStyle){
        let node = layout.node
        
        // Only leaf nodes should have a measure function
        if (layout.isLeaf) {
            LayoutStyle.YGRemoveAllChildren(node);
            
            if layout._owner is Label {
                YGNodeSetMeasureFunc(node, LayoutStyle.YGMeasureView);
            }
            
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
    
    static func YGApplyLayoutToViewHierarchy(_ layout:LayoutStyle,_ preserveOrigin:Bool)
    {
        if !layout.isIncludedInLayout {
            return
        }
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
