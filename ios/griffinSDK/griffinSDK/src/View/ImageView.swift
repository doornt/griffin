//
//  ImageView.swift
//  GriffinSDK
//
//  Created by sjtupt on 2017/12/26.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

class ImageView :UIImageView, ViewProtocol {
    
    func updateView(dict: Dictionary<String, Any>) {
        buildImageView(dict: dict)
    }
    
    convenience init(dict:Dictionary<String,Any>){
        self.init()
        self.isUserInteractionEnabled = false
        buildImageView(dict: dict)
    }
    
    func buildImageView(dict:Dictionary<String,Any>) {
        
        config(dict: dict)
        
        let url = URL.init(string: Utils.any2String(obj: dict["url"]) ?? "" )
        guard let rUrl = url,
            let data = try? Data.init(contentsOf: rUrl)  else {
                return
        }
        self.image = UIImage.init(data: data, scale: UIScreen.main.scale)
        
        if self.layer.cornerRadius > 0 {
            self.layer.masksToBounds = true
        }
    }
}
