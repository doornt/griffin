//
//  UIView+layout.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/2/12.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

extension UIView {
    
    var gnX: CGFloat {
        get {
            return frame.origin.x
        }
    }
    
    var gnY: CGFloat {
        get {
            return frame.origin.y
        }
    }
    
    var gnWidth: CGFloat {
        get {
            return frame.size.width
        }
    }
    
    var gnHeight: CGFloat {
        get {
            return frame.size.height
        }
    }
    
    var gnCenterX: CGFloat {
        get {
            return gnX + gnWidth/2.0
        }
        set {
            var oldFrame = frame
            oldFrame.origin.x = newValue - oldFrame.size.width/2.0
            frame = oldFrame
        }
    }
    
    var gnBottom: CGFloat {
        get {
            guard let superView = self.superview else {
                return 0
            }
            return superView.gnHeight - (frame.size.height + frame.origin.y)
        }
        set {
            guard let superView = self.superview else {
                return
            }
            var oldFrame = frame
            oldFrame.origin.y = superView.gnHeight - oldFrame.size.height - newValue
            frame = oldFrame
        }
    }
}
