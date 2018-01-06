//
//  Component.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/5.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class ViewComponent {
    
    lazy var _children: [ViewComponent] = []
    
    lazy var _viewLoaded = false
    
    var _view:UIView?
    
    var _layout:LayoutNode?
    
    required init(ref:String,styles:Dictionary<String,Any>) {
        
        _config(styles)
    }
    
    func _config(_ dict:Dictionary<String,Any>){
        
        let view = loadView()
        
        let w:CGFloat = Utils.any2CGFloat(dict["width"]) ?? 0
        let h:CGFloat = Utils.any2CGFloat(dict["height"]) ?? 0
        let y:CGFloat = Utils.any2CGFloat(dict["top"]) ?? 0
        let x:CGFloat = Utils.any2CGFloat(dict["left"]) ?? 0
        view.frame = CGRect(x: x, y: y, width: w, height: h)
        
        if Utils.hexString2UIColor(Utils.any2String(dict["background-color"])) != nil {
            view.backgroundColor = Utils.hexString2UIColor(Utils.any2String(dict["background-color"]))
        }
        
        view.clipsToBounds = Utils.any2Bool(dict["overflow"]) ?? false
        view.alpha = Utils.any2CGFloat(dict["opacity"]) ?? 1.0
        
        view.layer.borderWidth = Utils.any2CGFloat(dict["borderWidth"]) ?? 0
        
        if Utils.hexString2UIColor(Utils.any2String(dict["borderColor"])) != nil {
            view.layer.borderColor = Utils.hexString2UIColor(Utils.any2String(dict["borderColor"]))!.cgColor
        }
        
        view.layer.cornerRadius = Utils.any2CGFloat(dict["cornerRadius"]) ?? 0
        
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
//        for child in Utils.any2Array(dict["children"]) {
//            let rChild = child as? Dictionary<String, Any>
//            guard let realChild = rChild else {
//                continue
//            }
//            let childView: View = View(dict: realChild)
//            view.addSubview(childView)
//        }
    }
    
    func addChild(_ child:ViewComponent){
        let superView = self.loadView()
        let subView = child.loadView()
        
        superView.addSubview(subView)
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
    
    var view: UIView{
        if self._view != nil {
            return self._view!
        }
        self._view = loadView()
        return self._view!
    }
    
}
