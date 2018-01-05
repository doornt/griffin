//
//  Layout.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/3.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

extension ViewComponent{
    
    
    func initLayoutWithStyles(styles:Dictionary<String,Any>){
//        self._layout = LayoutNode.init(styles: styles,owner: self)
    }
    
    var layout: LayoutNode?{
        return self._layout
    }
}
