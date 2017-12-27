//
//  Log.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/25.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import Foundation

class Log{
    private static func log(level:String,fileName:String,line:Int,message:String){
        print("<Griffin>[\(level)]\(fileName):\(line),\(message)")
    }
    
    static func info(fileName:String,line:Int,message:String){
        self.log(level: "info", fileName: fileName, line: line, message: message)
    }
}


