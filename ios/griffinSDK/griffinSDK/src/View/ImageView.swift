//
//  ImageView.swift
//  GriffinSDK
//
//  Created by sjtupt on 2017/12/26.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

class ImageView : ViewComponent {
    
    lazy var _imageView: UIImageView = {
        
        let imageview = UIImageView.init()
        imageview.isUserInteractionEnabled = false
        return UIImageView.init()
        
    }()
    
    private var _imageUrl: String = ""
    
    required init(ref:String,styles:Dictionary<String,Any>) {
        
        super.init(ref: ref, styles: styles)

        _config(styles: styles)
        
    }
    
    func _config(styles:Dictionary<String,Any>) {
        _imageUrl =  Utils.any2String(styles["url"]) ?? ""
    }
    
    override func loadView() -> UIView {
        return self._imageView;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let imageView = self._view as? UIImageView else {
            return
        }
        
        imageView.setGriffinImage(with: _imageUrl)
        
        if imageView.layer.cornerRadius > 0 {
            imageView.layer.masksToBounds = true
        }
    }
    
    override func updateWithStyle(_ styles: Dictionary<String, Any>) {
        super.updateWithStyle(styles)
        _config(styles: styles)
    }

}
