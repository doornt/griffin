//
//  Layout.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/3.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

//import YogaKit

extension ViewComponent{
    
    func initLayoutWithStyles(styles:Dictionary<String,Any>){
        _layout = LayoutStyle.init(styles: styles,owner: self)
    }
    
    var layout: LayoutStyle{
        return self._layout!
    }
    
    var yoga:YGLayout?{
        var view:UIView? = nil

        if Thread.main != Thread.current {
            DispatchQueue.main.sync {
                view = self.loadView()
            }
        } else {
            view = self.loadView()        }
        return view?.yoga
    }
    
    func layoutFinish(){
        assert(Thread.current == Thread.main, "layoutFinish must be called in main thread")
        let view:UIView = self.loadView()
        view.frame = view.yoga.requestFrame
        self._needsLayout = false
    }
    
    var needsLayout : Bool{
        return self._needsLayout
    }
}
