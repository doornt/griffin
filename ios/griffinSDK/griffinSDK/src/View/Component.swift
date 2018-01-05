//
//  Component.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/5.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class ViewComponent{
    
    lazy var _children:[ViewComponent] = []
    
    lazy var _viewLoaded = false
    
    var _view:UIView?
    
    var _layout:LayoutNode?
    
    init(ref:String,styles:Dictionary<String,Any>) {
        
    }
    
    func addChild(_ child:ViewComponent){
        
    }
    
    func addChildAt(_ child:ViewComponent,_ index:Int){
        
    }
    
    func removeChild(_ child:ViewComponent){
        
    }
    
    func removeChildren(){
        
    }
    
    func loadView() -> UIView{
        let v = UIView.init()
        return v
    }
    
    var view:UIView{
        if self._view != nil {
            return self._view!
        }
        self._view = loadView()
        return self._view!
    }
    
}
