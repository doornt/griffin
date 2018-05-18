//
//  Label.swift
//  GriffinSDK
//
//  Created by sjtupt on 2017/12/26.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

class Label: ViewComponent {
    
    private lazy var _label: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 0
        return label
    }()
    
    var text: String = ""
    private var _textColorString: String = "#333333"
    var fontSize: CGFloat?
    
    private var _lastSize: CGSize = CGSize.init(width: -1, height: -1)
    
    private var _originWidth: YGValue?
    private var _originHeight: YGValue?
    
    required init(ref:String,styles:Dictionary<String,Any>,props:Dictionary<String,Any>) {
        super.init(ref: ref, styles: styles,props: props)
        _config(styles: styles)
    }
    
    private func _config(styles:Dictionary<String,Any>) {
        _textColorString = Utils.any2String(styles["color"]) ?? "#333333"
        fontSize = Utils.any2CGFloat(styles["font-size"])
    }
    
    override func updateProps(_ props: Dictionary<String, Any>) {
        super.updateProps(props)
        text = Utils.any2String(props["text"]) ?? ""
    }
    
    override var view: UIView {
        return self._label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let label = self.view as? UILabel else {
            return
        }
    
        label.text = text
        
        if Utils.hexString2UIColor(_textColorString) != nil {
            label.textColor = Utils.hexString2UIColor(_textColorString)
        }
        
        if fontSize != nil {
            label.font = UIFont.systemFont(ofSize: fontSize!)
            
        }
        
        if label.layer.cornerRadius > 0 {
            label.layer.masksToBounds = true
        }
    }

    override func updateWithStyle(_ styles: Dictionary<String, Any>) {
        super.updateWithStyle(styles)
        _config(styles: styles)
    }
}
