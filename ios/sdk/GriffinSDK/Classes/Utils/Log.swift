//
//  Log.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/25.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import Foundation

class Log {
    
    enum LogLevel: UInt {
        case Info = 0
        case Warning = 1
        case Error = 2
    }
    
    static var logLevel:LogLevel = .Error
    
    private static func log(level:String,fileName:String,line:Int,message:String){
        print("<Griffin>[\(level)]\(fileName):\(line),\(message)")
    }
    
    static func info(fileName:String,line:Int,message:String){
        self.log(level: "info", fileName: fileName, line: line, message: message)
    }

    private static func Log<T>(level:LogLevel,file:String,line:Int,function:String, message:T) {
        
        if level.rawValue < logLevel.rawValue {
            return
        }
        let fileName = (file as NSString).lastPathComponent
        var slevel = "error"
        switch level {
        case .Info:
            slevel = "info"
            break
        case .Warning:
            slevel = "warning"
            break
        case .Error:
            slevel = "error"
            break
        }
        print("<Griffin>[\(slevel)]\(fileName):\(line) \(function) | \(message)")
    }
    
    static func Info<T>(_ message:T, file:String = #file, function:String = #function,
                  line:Int = #line) {
        Log(level: .Info, file: file, line: line, function: function, message: message)
    }
    
    static func Warning<T>(_ message:T, file:String = #file, function:String = #function,
                           line:Int = #line) {
        Log(level: .Warning, file: file, line: line, function: function, message: message)
    }
    
    static func Error<T>(_ message:T, file:String = #file, function:String = #function,
                           line:Int = #line) {
        Log(level: .Error, file: file, line: line, function: function, message: message)
    }
}
