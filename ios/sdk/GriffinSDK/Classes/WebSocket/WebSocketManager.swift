//
//  WebSocketManager.swift
//  GriffinSDK
//
//  Created by sampson on 2018/2/3.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

private let timeoutDuration : CFTimeInterval = 30


class WebSocketManager {
    var queue = DispatchQueue(label: "SwiftWebSocketInstance", attributes: [])
    var once = Int()
    var mutex = pthread_mutex_t()
    var cond = pthread_cond_t()
    var websockets = Set<InnerWebSocket>()
    var _nextId = 0
    
    static let instance:WebSocketManager = {
        return WebSocketManager()
    }()
    
    private init(){
        pthread_mutex_init(&mutex, nil)
        pthread_cond_init(&cond, nil)
        DispatchQueue(label: "SwiftWebSocket", attributes: []).async {
            var wss : [InnerWebSocket] = []
            while true {
                var wait = true
                wss.removeAll()
                pthread_mutex_lock(&self.mutex)
                for ws in self.websockets {
                    wss.append(ws)
                }
                for ws in wss {
                    self.checkForConnectionTimeout(ws)
                    if ws.dirty {
                        pthread_mutex_unlock(&self.mutex)
                        ws.step()
                        pthread_mutex_lock(&self.mutex)
                        wait = false
                    }
                }
                if wait {
                    _ = self.wait(250)
                }
                pthread_mutex_unlock(&self.mutex)
            }
        }
    }
    func checkForConnectionTimeout(_ ws : InnerWebSocket) {
        if ws.rd != nil && ws.wr != nil && (ws.rd.streamStatus == .opening || ws.wr.streamStatus == .opening) {
            let age = CFAbsoluteTimeGetCurrent() - ws.createdAt
            if age >= timeoutDuration {
                ws.connectionTimeout = true
            }
        }
    }
    func wait(_ timeInMs : Int) -> Int32 {
        var ts = timespec()
        var tv = timeval()
        gettimeofday(&tv, nil)
        ts.tv_sec = time(nil) + timeInMs / 1000;
        let v1 = Int(tv.tv_usec * 1000)
        let v2 = Int(1000 * 1000 * Int(timeInMs % 1000))
        ts.tv_nsec = v1 + v2;
        ts.tv_sec += ts.tv_nsec / (1000 * 1000 * 1000);
        ts.tv_nsec %= (1000 * 1000 * 1000);
        return pthread_cond_timedwait(&self.cond, &self.mutex, &ts)
    }
    func signal(){
        pthread_mutex_lock(&mutex)
        pthread_cond_signal(&cond)
        pthread_mutex_unlock(&mutex)
    }
    func add(_ websocket: InnerWebSocket) {
        pthread_mutex_lock(&mutex)
        websockets.insert(websocket)
        pthread_cond_signal(&cond)
        pthread_mutex_unlock(&mutex)
    }
    func remove(_ websocket: InnerWebSocket) {
        pthread_mutex_lock(&mutex)
        websockets.remove(websocket)
        pthread_cond_signal(&cond)
        pthread_mutex_unlock(&mutex)
    }
    func nextId() -> Int {
        pthread_mutex_lock(&mutex)
        defer { pthread_mutex_unlock(&mutex) }
        _nextId += 1
        return _nextId
    }
}
