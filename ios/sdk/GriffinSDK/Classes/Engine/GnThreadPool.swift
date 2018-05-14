//
//  GnThreadPool.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/5/14.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

extension GnThreadPool {
    @objc func performOnJSThread(block: @convention(block)() -> Void ) {
        if Thread.current === self._jsThread {
            block()
        } else {
            self.perform(#selector(self.performOnJSThread(block:)), on: self._jsThread, with: block, waitUntilDone: false)
        }
    }
    
    @objc func performOnComponentThread(block: @convention(block)() -> Void ) {
        
        if Thread.current === self._componentThread {
            block()
        } else {
            self.perform(#selector(self.performOnComponentThread(block:)), on: self._componentThread, with: block, waitUntilDone: false)
        }
    }
}

class GnThreadPool: NSObject {
    
    private lazy var _jsThread: Thread = {
        let thread = Thread.init(target: self, selector: #selector(self.run), object: nil)
        thread.name = JSBridgeThreadName
        thread.start()
        return thread
    }()
    
    lazy var _componentThread: Thread = {
        let thread = Thread.init(target: self, selector: #selector(self.run), object: nil)
        thread.name = ComponentThreadName
        thread.start()
        return thread
    }()

    private let _stopRunning = false
    
    public static let instance: GnThreadPool = {
        return GnThreadPool()
    }()

    @objc private func run() {
        RunLoop.current.add(Port.init(), forMode: RunLoopMode.defaultRunLoopMode)
        while (!_stopRunning && RunLoop.current.run(mode: .defaultRunLoopMode, before: Date.distantFuture)){}
    }
}