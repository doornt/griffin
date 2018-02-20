//
//  Layout.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/3.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

//import YogaKit

extension ViewComponent{
    
    func initLayoutWithStyles(styles:Dictionary<String,Any>){
        _layout = LayoutStyle.init(styles: styles,owner: self)
    }
    
    var layout: LayoutStyle{
        get {
            
            return self._layout!
        }
        set {
            self._layout = newValue
        }
    }
    
    var childrenLayouts:[LayoutStyle]{
        var children:[LayoutStyle] = []
        for child in self.children {
            children.append(child.layout)
        }
        return children
    }
    
    func applyLayout() -> Void {
        self.layout.applyLayoutPreservingOrigin(preserveOrigin: true)
    }

    
    
    var needsLayout : Bool{
        return self._needsLayout
    }
    
    func configureLayout(_ block:(LayoutStyle)->Void){
        block(self.layout)
    }
}
