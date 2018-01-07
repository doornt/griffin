//
//  Div.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/5.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import UIKit

class DivView : ViewComponent {
    
    lazy var _divView: UIView = {
        return UIView.init()
    }()

    required init(ref:String,styles:Dictionary<String,Any>) {
        super.init(ref: ref, styles: styles)
    }
    
    override func loadView() -> UIView {
        return self._divView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func updateWithStyle(_ styles: Dictionary<String, Any>) {
        super.updateWithStyle(styles)
    }
}
