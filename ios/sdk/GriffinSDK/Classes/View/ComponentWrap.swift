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
        Log.Info("componentWrap Style \(styles)")
        var mStyle = styles
        mStyle.merge(["heigh":"100%", "width":"100%", "max-height":"100%","flex-grow":Float(1.0)]) { (current, _) in current}
        Log.Info("componentWrap Style after merged \(mStyle)")
        super.init(ref: ref, styles: mStyle, props: props)
    }
    
    override func loadView() -> UIView {
        return self._divView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JSBridgeContext.instance.performOnJSThread {
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

