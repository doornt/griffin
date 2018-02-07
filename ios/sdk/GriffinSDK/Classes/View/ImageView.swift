//
//  ImageView.swift
//  GriffinSDK
//
//  Created by sjtupt on 2017/12/26.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

class ImageView : ViewComponent {
    
    private lazy var _imageView: UIImageView = {
        let imageview = UIImageView.init()
        imageview.isUserInteractionEnabled = false
        return imageview
    }()
    
    private var _imageUrl: String?
    
    required init(ref:String,styles:Dictionary<String,Any>,props:Dictionary<String,Any>) {
        
        super.init(ref: ref, styles: styles, props: props)
    }
    
    override func updateProps(_ props: Dictionary<String, Any>) {
        super.updateProps(props)
        if let url = props.toString(key: "url"){
            _imageUrl = url
        }
    }
    
    override var styles: Dictionary<String, Any>{
        get{
            return super.styles
        }
        set{
            super.styles = newValue
            
            
        }
    }
    
    override func loadView() -> UIView {
        return self._imageView;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let imageView = self.view as? UIImageView else {
            return
        }
        
        imageView.setGriffinImage(with: _imageUrl!)
        
        if imageView.layer.cornerRadius > 0 {
            imageView.layer.masksToBounds = true
        }
    }
    
    override func updateWithStyle(_ styles: Dictionary<String, Any>) {
        super.updateWithStyle(styles)
    }
}
