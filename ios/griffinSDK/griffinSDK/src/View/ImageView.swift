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
    
    required init(ref:String,styles:Dictionary<String,Any>) {
        
        super.init(ref: ref, styles: styles)

        self._imageView.setGriffinImage(with: Utils.any2String(styles["url"]) ?? "")
        
        if self._imageView.layer.cornerRadius > 0 {
            self._imageView.layer.masksToBounds = true
        }

    }
    
    override func loadView() -> UIView {
        return self._imageView;
    }
    
//    func update(_ dict: Dictionary<String, Any>) {
//        setup(dict)
//    }

}
