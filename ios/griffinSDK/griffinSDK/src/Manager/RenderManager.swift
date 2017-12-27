//
//  RenderManager.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/8.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit
import JavaScriptCore

class RenderManager : NSObject{
    
    var _rootController:BaseViewController?
    
    var viewCollection: [String: UIView] = Dictionary()
    
    static let instance:RenderManager = {
        return RenderManager()
    }()
    
    private override init() {
        super.init()
    }
    
    func setRootController(root:BaseViewController){
        self._rootController = root
    }
    
    func createRootView(instanceId:String) -> Void {
        let rootview = View.init(frame: CGRect.init(x: 0, y: 0, width: Environment.instance.screenWidth, height: Environment.instance.screenHeight))
        rootview.instanceId = instanceId
        viewCollection[instanceId] = rootview
    
        self._rootController?.setRootView(rootview)
    }
    
    func createView(_ instanceId:String, obj:Dictionary<String,Any>) {
        let view = View.init(dict: obj)
        view.instanceId = instanceId
        viewCollection[instanceId] = view
    }
    
    func createLabel(_ instanceId:String, obj:Dictionary<String,Any>) {
        let label = Label.init(dict: obj)
        label.instanceId = instanceId
        viewCollection[instanceId] = label
    }
    
    func createImageView(_ instanceId:String, obj:Dictionary<String,Any>) {
        let imageview = ImageView.init(dict: obj)
        imageview.instanceId = instanceId
        viewCollection[instanceId] = imageview
    }
    
    func addsubView(_ parentId:String, childId: String){
        guard let parentView = viewCollection[parentId],
            let childView = viewCollection[childId] else {
                return
        }
        parentView.addSubview(childView)
    }
    
    func updateView(_ instanceId:String, data: Dictionary<String,Any>) {
        guard let view = viewCollection[instanceId] else {
            return
        }
        (view as? ViewProtocol )?.updateView(dict: data)
    }

    
    func registerEvent(_ instanceId:String, event: String, callBack: JSValue){
        guard let view = viewCollection[instanceId] else {
            return
        }
        
        view.registerEvent(event, callBack: callBack)
    }
    
    func unRegisterEvent(_ instanceId:String, event: String, callBack: JSValue){
        guard let view = viewCollection[instanceId] else {
            return
        }
        view.unRegisterEvent(event, callBack: callBack)
    }
}
