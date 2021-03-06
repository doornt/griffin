//
//  Div.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/5.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import UIKit

class DivView : ViewComponent {
    
    private lazy var _divView: UIView = {
        let view = UIView.init()
        return view
    }()
    
    required init(ref:String,styles:Dictionary<String,Any>,props:Dictionary<String,Any>) {
        super.init(ref: ref, styles: styles, props:props)
        
    }
    
    override var view: UIView {
        return self._divView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func updateWithStyle(_ styles: Dictionary<String, Any>) {
        super.updateWithStyle(styles)
    }
}
