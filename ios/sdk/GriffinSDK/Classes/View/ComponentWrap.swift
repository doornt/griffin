//
//  Div.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/5.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import UIKit

class ComponentWrap : ViewComponent {
    
    private lazy var _divView: UIView = {
        let view = UIView.init()
        return view
    }()
    
    required init(ref:String,styles:Dictionary<String,Any>,props:Dictionary<String,Any>) {
        var mStyle = styles
        mStyle.merge(["heigh":"100%", "width":"100%", "max-height":"100%","flex-grow":Float(1.0)]) { (current, _) in current}
        super.init(ref: ref, styles: mStyle, props: props)
    }
    
    override var view: UIView {
        return self._divView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GnThreadPool.instance.performOnJSThread {
            guard let rootviewId = self.rootViewId else {
                Log.Error("ComponentWrap DidLoad while rootviewId == nil")
                return
            }
            JSBridgeContext.instance.dispatchEventToJs(rootviewId: rootviewId, data: ["nodeId":self.ref, "event": "onAdded"])
        }
    }
    
    override func updateWithStyle(_ styles: Dictionary<String, Any>) {
        super.updateWithStyle(styles)
    }
}

