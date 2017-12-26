//
//  RenderManager.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/8.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit
import JavaScriptCore

public class RenderManager : NSObject{
    
    var _rootController:BaseViewController?
    
    var viewCollection: [String: UIView] = Dictionary()
    
    public static let instance:RenderManager = {
        return RenderManager()
    }()
    
    private override init() {
        super.init()
    }
    
    public func setRootController(root:BaseViewController){
        self._rootController = root
    }
    
    public func createRootView(instanceId:String) -> Void {
        let rootview = View.init(frame: CGRect.init(x: 0, y: 0, width: Environment.instance.screenWidth, height: Environment.instance.screenHeight))
        rootview.instanceId = instanceId
        viewCollection[instanceId] = rootview
    
        self._rootController?.setRootView(rootview)
    }
    
    public func createView(_ instanceId:String, obj:Dictionary<String,Any>) {
        let view = View.init(dict: obj)
        view.instanceId = instanceId
        viewCollection[instanceId] = view
    }
    
    public func createLabel(_ instanceId:String, obj:Dictionary<String,Any>) {
        let label = Label.init(dict: obj)
        label.instanceId = instanceId
        viewCollection[instanceId] = label
    }
    
    public func createImageView(_ instanceId:String, obj:Dictionary<String,Any>) {
        let imageview = ImageView.init(dict: obj)
        imageview.instanceId = instanceId
        viewCollection[instanceId] = imageview
    }
    
    public func addsubView(_ parentId:String, childId: String){
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

    
    public func registerEvent(_ instanceId:String, event: String, callBack: JSValue){
        guard let view = viewCollection[instanceId] else {
            return
        }
        if view.events == nil {
            view.events = Dictionary()
        }
        
        if view.events![event] == nil {
            var array: [JSValue] = Array()
            array.append(callBack)
            view.events![event] = array
        } else {
            var array = view.events![event]
            array?.append(callBack)
        }
    }
    
    public func unRegisterEvent(_ instanceId:String, event: String, callBack: JSValue){
        guard let view = viewCollection[instanceId],
              var eventDic = view.events,
              let eventArr = eventDic[event] else {
            return
        }
        
        eventDic[event] = eventArr.filter { $0 != callBack }
        view.events = eventDic
    }
    
    public func registerVCLifeCycle(_ instanceId:String, event: String, callBack: JSValue){
        guard let view = viewCollection[instanceId] else {
            return
        }
        
        if view.lifeCycleDict == nil {
            view.lifeCycleDict = Dictionary()
        }
        
        view.lifeCycleDict![event] = callBack
    }
}
