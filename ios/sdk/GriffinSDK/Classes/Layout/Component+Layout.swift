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
        return self._layout!
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

    func layoutFinish(){
        assert(Thread.current == Thread.main, "layoutFinish must be called in main thread")
        let view:UIView = self.loadView()
        view.frame = self.layout.requestFrame
//        self._needsLayout = false
    }
    
    var needsLayout : Bool{
        return self._needsLayout
    }
    
    func configureLayout(_ block:(LayoutStyle)->Void){
        block(self.layout)
    }
}
