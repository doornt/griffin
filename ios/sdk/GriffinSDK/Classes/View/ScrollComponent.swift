//
//  ScrollComponent.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/21.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class ScrollComponent: DivView {
    
    private lazy var _scrollView: UIScrollView? = {
        
        let scrollView = UIScrollView.init(frame: CGRect.zero)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    
    override var styles: Dictionary<String, Any>{
        get{
            return super.styles
        }
        set{
            super.styles = newValue
        }
    }
    
    override func updateProps(_ props: Dictionary<String, Any>) {
        super.updateProps(props)
    }
    
    override var view: UIView {
        return self._scrollView!
    }
    
    override func layoutFinish() {
        super.layoutFinish()
        
        
        var (totalW, totalH) = (self.layout.requestFrame.width, self.layout.requestFrame.height)
        
        for item in self.children {
            totalW = max(item.layout.requestFrame.width + item.layout.requestFrame.origin.x, totalW)
            totalH = max(item.layout.requestFrame.height + item.layout.requestFrame.origin.y, totalH)
        }
        
        _scrollView?.contentSize = CGSize.init(width: totalW, height: totalH)
//        print("iii", self.layout.requestFrame, _scrollView?.contentSize)
    }
}

