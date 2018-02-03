//
//  Defines.swift
//  GriffinSDK
//
//  Created by sampson on 2018/2/3.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

let windowBufferSize = 0x2000
let atEndDetails = "streamStatus.atEnd"
let timeoutDetails = "The operation couldn’t be completed. Operation timed out"

class Payload {
    var ptr : UnsafeMutableRawPointer
    var cap : Int
    var len : Int
    init(){
        len = 0
        cap = windowBufferSize
        ptr = malloc(cap)
    }
    deinit{
        free(ptr)
    }
    var count : Int {
        get {
            return len
        }
        set {
            if newValue > cap {
                while cap < newValue {
                    cap *= 2
                }
                ptr = realloc(ptr, cap)
            }
            len = newValue
        }
    }
    func append(_ bytes: UnsafePointer<UInt8>, length: Int){
        let prevLen = len
        count = len+length
        memcpy(ptr+prevLen, bytes, length)
    }
    var array : [UInt8] {
        get {
            var array = [UInt8](repeating: 0, count: count)
            memcpy(&array, ptr, count)
            return array
        }
        set {
            count = 0
            append(newValue, length: newValue.count)
        }
    }
    var nsdata : Data {
        get {
            return Data(bytes: ptr.assumingMemoryBound(to: UInt8.self), count: count)
        }
        set {
            count = 0
            append((newValue as NSData).bytes.bindMemory(to: UInt8.self, capacity: newValue.count), length: newValue.count)
        }
    }
    var buffer : UnsafeBufferPointer<UInt8> {
        get {
            return UnsafeBufferPointer<UInt8>(start: ptr.assumingMemoryBound(to: UInt8.self), count: count)
        }
        set {
            count = 0
            append(newValue.baseAddress!, length: newValue.count)
        }
    }
}

class UTF8 {
    var text : String = ""
    var count : UInt32 = 0          // number of bytes
    var procd : UInt32 = 0          // number of bytes processed
    var codepoint : UInt32 = 0      // the actual codepoint
    var bcount = 0
    init() { text = "" }
    func append(_ byte : UInt8) throws {
        if count == 0 {
            if byte <= 0x7F {
                text.append(String(UnicodeScalar(byte)))
                return
            }
            if byte == 0xC0 || byte == 0xC1 {
                throw WebSocketError.payloadError("invalid codepoint: invalid byte")
            }
            if byte >> 5 & 0x7 == 0x6 {
                count = 2
            } else if byte >> 4 & 0xF == 0xE {
                count = 3
            } else if byte >> 3 & 0x1F == 0x1E {
                count = 4
            } else {
                throw WebSocketError.payloadError("invalid codepoint: frames")
            }
            procd = 1
            codepoint = (UInt32(byte) & (0xFF >> count)) << ((count-1) * 6)
            return
        }
        if byte >> 6 & 0x3 != 0x2 {
            throw WebSocketError.payloadError("invalid codepoint: signature")
        }
        codepoint += UInt32(byte & 0x3F) << ((count-procd-1) * 6)
        if codepoint > 0x10FFFF || (codepoint >= 0xD800 && codepoint <= 0xDFFF) {
            throw WebSocketError.payloadError("invalid codepoint: out of bounds")
        }
        procd += 1
        if procd == count {
            if codepoint <= 0x7FF && count > 2 {
                throw WebSocketError.payloadError("invalid codepoint: overlong")
            }
            if codepoint <= 0xFFFF && count > 3 {
                throw WebSocketError.payloadError("invalid codepoint: overlong")
            }
            procd = 0
            count = 0
            text.append(String.init(describing: UnicodeScalar(codepoint)!))
        }
        return
    }
    func append(_ bytes : UnsafePointer<UInt8>, length : Int) throws {
        if length == 0 {
            return
        }
        if count == 0 {
            var ascii = true
            for i in 0 ..< length {
                if bytes[i] > 0x7F {
                    ascii = false
                    break
                }
            }
            if ascii {
                text += NSString(bytes: bytes, length: length, encoding: String.Encoding.ascii.rawValue)! as String
                bcount += length
                return
            }
        }
        for i in 0 ..< length {
            try append(bytes[i])
        }
        bcount += length
    }
    var completed : Bool {
        return count == 0
    }
    static func bytes(_ string : String) -> [UInt8]{
        let data = string.data(using: String.Encoding.utf8)!
        return [UInt8](UnsafeBufferPointer<UInt8>(start: (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), count: data.count))
    }
    static func string(_ bytes : [UInt8]) -> String{
        if let str = NSString(bytes: bytes, length: bytes.count, encoding: String.Encoding.utf8.rawValue) {
            return str as String
        }
        return ""
    }
}

enum OpCode : UInt8, CustomStringConvertible {
    case `continue` = 0x0, text = 0x1, binary = 0x2, close = 0x8, ping = 0x9, pong = 0xA
    var isControl : Bool {
        switch self {
        case .close, .ping, .pong:
            return true
        default:
            return false
        }
    }
    var description : String {
        switch self {
        case .`continue`: return "Continue"
        case .text: return "Text"
        case .binary: return "Binary"
        case .close: return "Close"
        case .ping: return "Ping"
        case .pong: return "Pong"
        }
    }
}

class Frame {
    var code = OpCode.continue
    var utf8 = UTF8()
    var payload = Payload()
    var statusCode = UInt16(0)
    var finished = true
    static func makeClose(_ statusCode: UInt16, reason: String) -> Frame {
        let f = Frame()
        f.code = .close
        f.statusCode = statusCode
        f.utf8.text = reason
        return f
    }
    func copy() -> Frame {
        let f = Frame()
        f.code = code
        f.utf8.text = utf8.text
        f.payload.buffer = payload.buffer
        f.statusCode = statusCode
        f.finished = finished
        return f
    }
}


enum WebSocketBinaryType : CustomStringConvertible {
    /// The WebSocket should transmit [UInt8] objects.
    case uInt8Array
    /// The WebSocket should transmit NSData objects.
    case nsData
    /// The WebSocket should transmit UnsafeBufferPointer<UInt8> objects. This buffer is only valid during the scope of the message event. Use at your own risk.
    case uInt8UnsafeBufferPointer
    public var description : String {
        switch self {
        case .uInt8Array: return "UInt8Array"
        case .nsData: return "NSData"
        case .uInt8UnsafeBufferPointer: return "UInt8UnsafeBufferPointer"
        }
    }
}

@objc public protocol WebSocketDelegate {
    /// A function to be called when the WebSocket connection's readyState changes to .Open; this indicates that the connection is ready to send and receive data.
    func webSocketOpen()
    /// A function to be called when the WebSocket connection's readyState changes to .Closed.
    func webSocketClose(_ code: Int, reason: String, wasClean: Bool)
    /// A function to be called when an error occurs.
    func webSocketError(_ error: NSError)
    /// A function to be called when a message (string) is received from the server.
    @objc optional func webSocketMessageText(_ text: String)
    /// A function to be called when a message (binary) is received from the server.
    @objc optional func webSocketMessageData(_ data: Data)
    /// A function to be called when a pong is received from the server.
    @objc optional func webSocketPong()
    /// A function to be called when the WebSocket process has ended; this event is guarenteed to be called once and can be used as an alternative to the "close" or "error" events.
    @objc optional func webSocketEnd(_ code: Int, reason: String, wasClean: Bool, error: NSError?)
}

@objc public enum WebSocketReadyState : Int, CustomStringConvertible {
    /// The connection is not yet open.
    case connecting = 0
    /// The connection is open and ready to communicate.
    case open = 1
    /// The connection is in the process of closing.
    case closing = 2
    /// The connection is closed or couldn't be opened.
    case closed = 3
    fileprivate var isClosed : Bool {
        switch self {
        case .closing, .closed:
            return true
        default:
            return false
        }
    }
    /// Returns a string that represents the ReadyState value.
    public var description : String {
        switch self {
        case .connecting: return "Connecting"
        case .open: return "Open"
        case .closing: return "Closing"
        case .closed: return "Closed"
        }
    }
}

public struct WebSocketEvents {
    /// An event to be called when the WebSocket connection's readyState changes to .Open; this indicates that the connection is ready to send and receive data.
    public var open : ()->() = {}
    /// An event to be called when the WebSocket connection's readyState changes to .Closed.
    public var close : (_ code : Int, _ reason : String, _ wasClean : Bool)->() = {(code, reason, wasClean) in}
    /// An event to be called when an error occurs.
    public var error : (_ error : Error)->() = {(error) in}
    /// An event to be called when a message is received from the server.
    public var message : (_ data : Any)->() = {(data) in}
    /// An event to be called when a pong is received from the server.
    public var pong : (_ data : Any)->() = {(data) in}
    /// An event to be called when the WebSocket process has ended; this event is guarenteed to be called once and can be used as an alternative to the "close" or "error" events.
    public var end : (_ code : Int, _ reason : String, _ wasClean : Bool, _ error : Error?)->() = {(code, reason, wasClean, error) in}
}

class ByteReader {
    var start : UnsafePointer<UInt8>
    var end : UnsafePointer<UInt8>
    var bytes : UnsafePointer<UInt8>
    init(bytes: UnsafePointer<UInt8>, length: Int){
        self.bytes = bytes
        start = bytes
        end = bytes+length
    }
    func readByte() throws -> UInt8 {
        if bytes >= end {
            throw WebSocketError.needMoreInput
        }
        let b = bytes.pointee
        bytes += 1
        return b
    }
    var length : Int {
        return end - bytes
    }
    var position : Int {
        get {
            return bytes - start
        }
        set {
            bytes = start + newValue
        }
    }
}
