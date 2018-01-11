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
    
//    func layoutFinish(){
//        let view:UIView = self.loadView()
//
//        if layout._layout_frame.width == 0{
//            return
//        }
//
//        view.frame = CGRect(x: layout._layout_frame.x, y: layout._layout_frame.y, width: layout._layout_frame.width, height: layout._layout_frame.height)
//
//    }
}
