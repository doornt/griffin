//
//  GnTimer.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/2/13.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class GnTimer {
    
    private weak var _timer: Timer?
    private weak var _target: AnyObject?
    private var _selector: Selector?
    
    init(timeInterval: TimeInterval, target:AnyObject, selector: Selector, repeats: Bool) {
        _target = target
        _selector = selector
        
        let timer = Timer.init(timeInterval: timeInterval, target: self, selector: #selector(timerHandler), userInfo: nil, repeats: repeats)
        RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        _timer = timer
    }
    
    @objc func timerHandler() {
        
        if _target != nil {
            let _ = _target?.perform(_selector)
        } else {
            _timer?.invalidate()
            _timer = nil
        }
    }
}
