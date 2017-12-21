//
//  View.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/21.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit


public class View :UIView{
    convenience init(dict:Dictionary<String,Any>){
        self.init()
        let w:CGFloat = dict["width"] != nil ? 100 : 0.0
        let h:CGFloat = dict["height"] != nil ? 100: 0.0
        let bgColor = dict["backgroundColor"] != nil ? UIColor.black : UIColor.gray
        
        self.frame = CGRect(x: 0, y: 0, width: w, height: h)
        self.backgroundColor = bgColor
        
    }
}
