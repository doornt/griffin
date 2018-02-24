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
        
        
        super.init(ref: ref, styles: ["heigh":"100%", "width":"100%", "max-height":"100%","flex-grow":0], props:props)
    }
    
    override func loadView() -> UIView {
        return self._divView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JSBridgeContext.instance.performOnJSThread {
            JSBridgeContext.instance.dispatchEventToJs(rootviewId: (RootComponentManager.instance.topComponent?.ref)!, data: ["nodeId":self.ref, "event": "onAdded"])
        }
    }
    
    override func updateWithStyle(_ styles: Dictionary<String, Any>) {
        super.updateWithStyle(styles)
    }
}

