//
//  Label.swift
//  GriffinSDK
//
//  Created by sjtupt on 2017/12/26.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

class Label: ViewComponent {
    
    lazy var _label: UILabel = {
        
        let label = UILabel.init()
        label.isUserInteractionEnabled = false
        return UILabel.init()
        
    }()
    
    required init(ref:String,styles:Dictionary<String,Any>) {
        super.init(ref: ref, styles: styles)
        
        self._label.text = Utils.any2String(styles["text"])
        
        if Utils.hexString2UIColor(Utils.any2String(styles["textColor"])) != nil {
            self._label.textColor = Utils.hexString2UIColor(Utils.any2String(styles["textColor"]))
        }
        
        if self._label.layer.cornerRadius > 0 {
            self._label.layer.masksToBounds = true
        }
        self._label.sizeToFit()
    }
    
    override func loadView() -> UIView {
        return self._label;
    }
    
//    func update(_ dict: Dictionary<String, Any>) {
//        setup(dict)
//    }

}
