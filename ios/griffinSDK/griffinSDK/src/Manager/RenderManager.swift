//
//  RenderManager.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/8.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

public class RenderManager : NSObject{
    
    var _rootController:BaseViewController?
    
    public static let instance:RenderManager = {
        return RenderManager()
    }()
    
    private override init() {
        super.init()
    }
    
    public func setRootController(root:BaseViewController){
        self._rootController = root
    }
    
    public func setRootView(obj:Any) -> Void {
        self._rootController?.view.addSubview(obj as? UIView ?? UIView.init())
    }
    
    public func createView(obj:Dictionary<String,Any>) -> View {
        return View.init(dict: obj)
    }
    public func createLabel(obj:Dictionary<String,Any>) -> Label {
        return Label.init(dict: obj)
    }
    public func createImageView(obj:Dictionary<String,Any>) -> ImageView {
        return ImageView.init(dict: obj)
    }
    public func useElement(obj:Any){
        self._rootController?.view.addSubview(obj as? UIView ?? UIView.init())
    }
    
    public func addsubView(_ obj:Any, childView: Any){
        let parentView = obj as? UIView ?? UIView.init()
        let rChildView = childView as? UIView ?? UIView.init()
        parentView.addSubview(rChildView)
    }
}
