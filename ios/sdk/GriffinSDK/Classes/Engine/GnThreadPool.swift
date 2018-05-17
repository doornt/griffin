//
//  GnThreadPool.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/5/14.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

extension GnThreadPool {
    @objc func performOnJSThread(block:@escaping @convention(block)() -> Void ) {
        if Thread.current === self._jsThread {
            block()
        } else {
            self.perform(#selector(self.performOnJSThread(block:)), on: self._jsThread, with: block, waitUntilDone: false)
        }
    }
    
    @objc func performOnJSThreadSync(block: @convention(block)() -> Void ) {
        if Thread.current === self._jsThread {
            block()
        } else {
            self.perform(#selector(self.performOnJSThreadSync(block:)), on: self._jsThread, with: block, waitUntilDone: true)
        }
    }
    @objc func performOnComponentThread(block:@escaping @convention(block)() -> Void ) {
        
        if Thread.current === self._componentThread {
            block()
        } else {
            self.perform(#selector(self.performOnComponentThread(block:)), on: self._componentThread, with: block, waitUntilDone: false)
        }
    }
    
    @objc func performOnComponentThreadSync(block: @convention(block)() -> Void ) {
        
        if Thread.current === self._componentThread {
            block()
        } else {
            self.perform(#selector(self.performOnComponentThreadSync(block:)), on: self._componentThread, with: block, waitUntilDone: true)
        }
    }
    
    @objc func performOnMainThread(block:@escaping @convention(block)() -> Void ) {
        
        if Thread.current === Thread.main {
            block()
        } else {
            self.perform(#selector(self.performOnMainThread(block:)), on: Thread.main, with: block, waitUntilDone: false)
        }
    }
    
    @objc func performOnMainThreadSync(block: @convention(block)() -> Void ) {
        
        if Thread.current === Thread.main {
            block()
        } else {
            self.perform(#selector(self.performOnMainThreadSync(block:)), on: Thread.main, with: block, waitUntilDone: true)
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
    
    private lazy var _componentThread: Thread = {
        let thread = Thread.init(target: self, selector: #selector(self.run), object: nil)
        thread.name = ComponentThreadName
        thread.start()
        return thread
    }()

    var componentThread: Thread {
        return _componentThread
    }
    var jsThread: Thread {
        return _jsThread
    }
    
    private let _stopRunning = false
    
    public static let instance: GnThreadPool = {
        return GnThreadPool()
    }()

    @objc private func run() {
        RunLoop.current.add(Port.init(), forMode: RunLoopMode.defaultRunLoopMode)
        while (!_stopRunning && RunLoop.current.run(mode: .defaultRunLoopMode, before: Date.distantFuture)){}
    }
}
