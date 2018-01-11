//
//  Log.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/25.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import Foundation

class Log {
    
    private static func log(level:String,fileName:String,line:Int,message:String){
        print("<Griffin>[\(level)]\(fileName):\(line),\(message)")
    }
    
    private static func Log<T>(level:String,file:String,line:Int,function:String, message:T) {
        let fileName = (file as NSString).lastPathComponent
        print("<Griffin>[\(level)]\(fileName):\(line) \(function) | \(message)")
    }
    
    static func info(fileName:String,line:Int,message:String){
        self.log(level: "info", fileName: fileName, line: line, message: message)
    }
    
    static func LogInfo<T>(_ message:T, file:String = #file, function:String = #function,
                  line:Int = #line) {
        Log(level: "info", file: file, line: line, function: function, message: message)
    }
    
    static func LogWarning<T>(_ message:T, file:String = #file, function:String = #function,
                           line:Int = #line) {
        Log(level: "warning", file: file, line: line, function: function, message: message)
    }
    
    static func LogError<T>(_ message:T, file:String = #file, function:String = #function,
                           line:Int = #line) {
        Log(level: "error", file: file, line: line, function: function, message: message)
    }
}
