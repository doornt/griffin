//
//  Slider.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/21.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class SliderView : DivView{
    
    private var _interval:CGFloat?
    
    private var _autoPlay:Bool = false
    
    required init(ref: String, styles: Dictionary<String, Any>,props:Dictionary<String, Any>) {
        super.init(ref: ref, styles: styles, props: props)
    }
    
    
    override var styles: Dictionary<String, Any>{
        get{
            return super.styles
        }
        set{
            super.styles = newValue
            
            if let interval = newValue.toCGFloat(key: "interval"){
                self._interval = interval
            }
            
            if let autoplay = newValue.toBool(key: "auto-play"){
                self._autoPlay = autoplay
            }
        }
    }
    
    
}
