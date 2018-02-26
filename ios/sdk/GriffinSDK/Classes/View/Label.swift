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
    
    private var _text: String = ""
    private var _textColorString: String = "#333333"
    private var _fontSize: CGFloat?
    
    private var _lastSize: CGSize = CGSize.init(width: -1, height: -1)
    
//    private var _originSize: CGSize = CGSize.zero

//    private var _sizeSetted:Bool = false
    
    private var _originWidth: YGValue?
    private var _originHeight: YGValue?
    
    required init(ref:String,styles:Dictionary<String,Any>,props:Dictionary<String,Any>) {
        super.init(ref: ref, styles: styles,props: props)
//        if Utils.any2YGValue(styles["width"]) != nil{
//            _sizeSetted = true
//        }
        _config(styles: styles)
    }
    
    private func _config(styles:Dictionary<String,Any>) {
        _textColorString = Utils.any2String(styles["color"]) ?? "#333333"
        _fontSize = Utils.any2CGFloat(styles["font-size"])
    }
    
    override func updateProps(_ props: Dictionary<String, Any>) {
        super.updateProps(props)
        _text = Utils.any2String(props["text"]) ?? ""
    }
    
//    func rejustView(){
//        _originSize = _label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
//
//        if !_sizeSetted  {
//            layout.width = YGValue(_originSize.width)
//            layout.height = YGValue(_originSize.height)
//        }
//        self._needsLayout = true
//
//    }
    
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
        
//        self.rejustView()
    }

    override func updateWithStyle(_ styles: Dictionary<String, Any>) {
        super.updateWithStyle(styles)
        _config(styles: styles)
    }

    override func layoutFinish() {

        super.layoutFinish()
        
        let newSize = CGSize.init(width: self.layout.requestFrame.width, height: self.layout.requestFrame.height)
        if _lastSize.equalTo(newSize) {
            return
        }
        _lastSize = newSize

        if _originWidth == nil {
            _originWidth = self.layout.width
        }
        if _originHeight == nil {
            _originHeight = self.layout.height
        }
        
        guard let originW = _originWidth, let originH = _originHeight else {
            return
        }
        var (constraintW, constraintH) = (CGFloat(self.layout.width.value), CGFloat(self.layout.height.value))

        if let parentW = self.parent?.layout.requestFrame.width {
            if originW.unit == YGUnitPercent {
                constraintW = CGFloat(originW.value / 100.0) * parentW
            }
        }
        if let parentH = self.parent?.layout.requestFrame.height {
            if originH.unit == YGUnitPercent {
                constraintH = CGFloat(originH.value / 100.0) * parentH
            }
        }

        let size = _label.sizeThatFits(CGSize(width: constraintW, height: constraintH))

        self.layout.width = YGValue(size.width)
        self.layout.height = YGValue(size.height)
        
        self._needsLayout = true
    }
}
