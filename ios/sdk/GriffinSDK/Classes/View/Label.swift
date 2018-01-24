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
        label.isUserInteractionEnabled = false
        return UILabel.init()
    }()
    
    private var _text: String = ""
    private var _textColorString: String = "#333333"
    private var _fontSize: CGFloat?
    
    required init(ref:String,styles:Dictionary<String,Any>) {
        super.init(ref: ref, styles: styles)
        
        _config(styles: styles)
    }
    
    private func _config(styles:Dictionary<String,Any>) {
        _text = Utils.any2String(styles["text"]) ?? ""
        _textColorString = Utils.any2String(styles["color"]) ?? "#333333"
        _fontSize = Utils.any2CGFloat(styles["font-size"])
    }
    
    override func loadView() -> UIView {
        return self._label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let label = self.view as? UILabel else {
            return
        }
    
        label.text = _text
        
        if Utils.hexString2UIColor(_textColorString) != nil {
            label.textColor = Utils.hexString2UIColor(_textColorString)
        }
        
        if _fontSize != nil {
            label.font = UIFont.systemFont(ofSize: _fontSize!)
            
        }
        
        if label.layer.cornerRadius > 0 {
            label.layer.masksToBounds = true
        }
        
        let size = label.sizeThatFits(CGSize(width: CGFloat(self.layout.width.value), height: CGFloat(self.layout.height.value)))
        
        self.layout.width = YGValue(size.width)
        self.layout.height = YGValue(size.height)
        
        self._needsLayout = true
        
    }

    override func updateWithStyle(_ styles: Dictionary<String, Any>) {
        super.updateWithStyle(styles)
        _config(styles: styles)
    }

}
