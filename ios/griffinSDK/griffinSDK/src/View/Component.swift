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
    
    var _parent:ViewComponent?
    
    lazy var _viewLoaded = false
    
    var _view:UIView?
    
    var _layout:LayoutStyle?
    

    private var _frame = CGRect.zero
    private var _backgroundColor:String = "#000000"
    private var _isOverflow:Bool = false
    private var _alpha: CGFloat = 1.0
    private var _borderWidth: CGFloat = 0.0
    private var _borderColor = "#ffffff"
    private var _cornerRadius: CGFloat = 0.0
    
    required init(ref:String,styles:Dictionary<String,Any>) {
        _config(styles: styles)
    }
    
    private func _config(styles:Dictionary<String,Any>) {
        let w:CGFloat = Utils.any2CGFloat(styles["width"]) ?? 0
        let h:CGFloat = Utils.any2CGFloat(styles["height"]) ?? 0
        let y:CGFloat = Utils.any2CGFloat(styles["top"]) ?? 0
        let x:CGFloat = Utils.any2CGFloat(styles["left"]) ?? 0
        _frame = CGRect(x: x, y: y, width: w, height: h)
        
        _backgroundColor = Utils.any2String(styles["background-color"]) ?? "#000000"
        _isOverflow = Utils.any2Bool(styles["overflow"]) ?? false
        _alpha = Utils.any2CGFloat(styles["opacity"]) ?? 1.0
        _borderWidth = Utils.any2CGFloat(styles["borderWidth"]) ?? 0.0
        _borderColor = Utils.any2String(styles["borderColor"]) ?? "#ffffff"
        _cornerRadius = Utils.any2CGFloat(styles["cornerRadius"]) ?? 0
    }
    
    func addChild(_ child:ViewComponent){
        let superView = self.view
        let subView = child.view
        
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
    
    func refresh() {
        setupView()
    }
    
    func updateWithStyle(_ styles: Dictionary<String,Any>) {
        _config(styles: styles)
    }
    
    func viewDidLoad() {}
    
    var children:[ViewComponent]{
        return self._children
    }
    
    private func setupView() {
        
        self._view = loadView()
        
        self._view?.frame = _frame
        
        if Utils.hexString2UIColor(_backgroundColor) != nil {
            self._view?.backgroundColor = Utils.hexString2UIColor(_backgroundColor)
        }
        
        self._view?.clipsToBounds = _isOverflow
        self._view?.alpha = _alpha
        
        self._view?.layer.borderWidth = _borderWidth
        
        if Utils.hexString2UIColor(_borderColor) != nil {
            self._view?.layer.borderColor = Utils.hexString2UIColor(_borderColor)!.cgColor
        }
        
        self._view?.layer.cornerRadius = _cornerRadius
        
        self.viewDidLoad()
        //        for subview in view.subviews {
        //            subview.removeFromSuperview()
        //        }
        
        //        for child in Utils.any2Array(dict["children"]) {
        //            let rChild = child as? Dictionary<String, Any>
        //            guard let realChild = rChild else {
        //                continue
        //            }
        //            let childView: View = View(dict: realChild)
        //            view.addSubview(childView)
        //        }
    }
    
    var view:UIView{
        if self._view != nil {
            return self._view!
        }
        setupView()
        
        
        return self._view!
    }
    
    var parent:ViewComponent?{
        get{
            return self._parent
        }
        set{
            self._parent = newValue
        }
    }
    
}
