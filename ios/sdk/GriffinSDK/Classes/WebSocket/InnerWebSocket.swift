//
//  InnerWebSocket.swift
//  GriffinSDK
//
//  Created by sampson on 2018/2/3.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation


private class Delegate : NSObject, StreamDelegate {
    @objc func stream(_ aStream: Stream, handle eventCode: Stream.Event){
        WebSocketManager.instance.signal()
    }
}



class InnerWebSocket : Hashable{
    var hashValue: Int = 0
    var mutex = pthread_mutex_t()
    
    var createdAt = CFAbsoluteTimeGetCurrent()
    var connectionTimeout = false
    
    var frames : [Frame] = []
    
    var outputBytes : UnsafeMutablePointer<UInt8>?
    var outputBytesSize : Int = 0
    var outputBytesStart : Int = 0
    var outputBytesLength : Int = 0
    
    var inputBytes : UnsafeMutablePointer<UInt8>?
    var inputBytesSize : Int = 0
    var inputBytesStart : Int = 0
    var inputBytesLength : Int = 0
    
    var atEnd = false
    var closeCode = UInt16(0)
    var closeReason = ""
    var closeClean = false
    var closeFinal = false
    var finalError : Error?
    var exit = false
    var more = true
    var _event = WebSocketEvents()

    var _binaryType = WebSocketBinaryType.uInt8Array
    var _eventDelegate: WebSocketDelegate?
    var _readyState = WebSocketReadyState.connecting

    var head = [UInt8](repeating: 0, count: 0xFF)
    var readStateSaved = false
    var readStateFrame : Frame?
    var readStateFinished = false
    var leaderFrame : Frame?
    
    var manager:WebSocketManager = WebSocketManager.instance
    
    fileprivate var delegate:Delegate
    
    var rd : InputStream!
    var wr : OutputStream!
    
    var request:URLRequest
    
    var fragStateSaved = false
    var fragStatePosition = 0
    var fragStateInflate = false
    var fragStateLen = 0
    var fragStateFin = false
    var fragStateCode = OpCode.continue
    var fragStateLeaderCode = OpCode.continue
    var fragStateUTF8 = UTF8()
    var fragStatePayload = Payload()
    var fragStateStatusCode = UInt16(0)
    var fragStateHeaderLen = 0
    var buffer = [UInt8](repeating: 0, count: windowBufferSize)
    var reusedPayload = Payload()
    
    var eclose : ()->() = {}
    
    var _eventQueue : DispatchQueue? = DispatchQueue.main


    
    enum Stage : Int {
        case openConn
        case readResponse
        case handleFrames
        case closeConn
        case end
    }
    var stage = Stage.openConn
    
    var event : WebSocketEvents {
        get { lock(); defer { unlock() }; return _event }
        set { lock(); defer { unlock() }; _event = newValue }
    }
    var eventDelegate : WebSocketDelegate? {
        get { lock(); defer { unlock() }; return _eventDelegate }
        set { lock(); defer { unlock() }; _eventDelegate = newValue }
    }
    
    var binaryType : WebSocketBinaryType {
        get { lock(); defer { unlock() }; return _binaryType }
        set { lock(); defer { unlock() }; _binaryType = newValue }
    }
    var readyState : WebSocketReadyState {
        get { return privateReadyState }
    }
    var privateReadyState : WebSocketReadyState {
        get { lock(); defer { unlock() }; return _readyState }
        set { lock(); defer { unlock() }; _readyState = newValue }
    }
    var eventQueue : DispatchQueue? {
        get { lock(); defer { unlock() }; return _eventQueue; }
        set { lock(); defer { unlock() }; _eventQueue = newValue }
    }
    
    init(request:URLRequest) {
        pthread_mutex_init(&self.mutex, nil)
        self.request = request
        
        self.outputBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: windowBufferSize)
        self.outputBytesSize = windowBufferSize
        self.inputBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: windowBufferSize)
        self.inputBytesSize = windowBufferSize
        
        self.delegate = Delegate()
        self.hashValue = manager.nextId()
        
        manager.queue.asyncAfter(deadline: DispatchTime.now() + Double(0) / Double(NSEC_PER_SEC)){
            self.manager.add(self)
        }

    }
    
    deinit{
        if outputBytes != nil {
            free(outputBytes)
        }
        if inputBytes != nil {
            free(inputBytes)
        }
        pthread_mutex_destroy(&mutex)
    }
    
    @inline(__always) fileprivate func lock(){
        pthread_mutex_lock(&mutex)
    }
    @inline(__always) fileprivate func unlock(){
        pthread_mutex_unlock(&mutex)
    }
    
    func openConn() throws -> Void {
        request.setValue("websocket", forHTTPHeaderField: "Upgrade")
        request.setValue("Upgrade", forHTTPHeaderField: "Connection")
        if request.value(forHTTPHeaderField: "User-Agent") == nil {
            request.setValue("GriffinSDK WebSokcket", forHTTPHeaderField: "User-Agent")
        }
        request.setValue("13", forHTTPHeaderField: "Sec-WebSocket-Version")
        
        if request.url == nil || request.url!.host == nil{
            throw WebSocketError.invalidAddress
        }
        if request.url!.port == nil || request.url!.port! == 80 || request.url!.port! == 443 {
            request.setValue(request.url!.host!, forHTTPHeaderField: "Host")
        } else {
            request.setValue("\(request.url!.host!):\(request.url!.port!)", forHTTPHeaderField: "Host")
        }
        let origin = request.value(forHTTPHeaderField: "Origin")
        if origin == nil || origin! == ""{
            request.setValue(request.url!.absoluteString, forHTTPHeaderField: "Origin")
        }
        
        let port : Int
        if request.url!.scheme == "wss" {
            port = request.url!.port ?? 443
//            security = .negoticatedSSL
        } else {
            port = request.url!.port ?? 80
//            security = .none
        }
        
        
        var path = CFURLCopyPath(request.url! as CFURL!) as String
        if path == "" {
            path = "/"
        }
        if let q = request.url!.query {
            if q != "" {
                path += "?" + q
            }
        }
        var reqs = "GET \(path) HTTP/1.1\r\n"
        for key in request.allHTTPHeaderFields!.keys {
            if let val = request.value(forHTTPHeaderField: key) {
                reqs += "\(key): \(val)\r\n"
            }
        }
        
//        To prove that the handshake was received, the server has to take two
//        pieces of information and combine them to form a response.  The first
//        piece of information comes from the |Sec-WebSocket-Key| header field
//        in the client handshake:
//
//        Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
        
        var keyb = [UInt32](repeating: 0, count: 4)
        for i in 0 ..< 4 {
            keyb[i] = arc4random()
        }
        let rkey = Data(bytes: UnsafePointer(keyb), count: 16).base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        reqs += "Sec-WebSocket-Key: \(rkey)\r\n"
        reqs += "\r\n"
        var header = [UInt8]()
        for b in reqs.utf8 {
            header += [b]
        }
        
        let addr = ["\(request.url!.host!)", "\(port)"]
        if addr.count != 2 || Int(addr[1]) == nil {
            throw WebSocketError.invalidAddress
        }
        
        var (rdo, wro) : (InputStream?, OutputStream?)
        var readStream:  Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        CFStreamCreatePairWithSocketToHost(nil, addr[0] as CFString!, UInt32(Int(addr[1])!), &readStream, &writeStream);
        rdo = readStream!.takeRetainedValue()
        wro = writeStream!.takeRetainedValue()
        (rd, wr) = (rdo!, wro!)
        
        //it doesn't support wss now
//        rd.setProperty(nil, forKey: Stream.PropertyKey.socketSecurityLevelKey)
//        wr.setProperty(nil, forKey: Stream.PropertyKey.socketSecurityLevelKey)
        
        rd.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        wr.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        rd.delegate = delegate
        wr.delegate = delegate
        rd.open()
        wr.open()
        try write(header, length: header.count)
    }
    
    func closeConn() {
        rd.remove(from: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        wr.remove(from: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        rd.delegate = nil
        wr.delegate = nil
        rd.close()
        wr.close()
    }
    
    func write(_ bytes: UnsafePointer<UInt8>, length: Int) throws {
        if outputBytesStart+outputBytesLength+length > outputBytesSize {
            var size = outputBytesSize
            while outputBytesStart+outputBytesLength+length > size {
                size *= 2
            }
            let ptr = realloc(outputBytes, size)
            if ptr == nil {
                throw WebSocketError.memory
            }
            outputBytes = ptr?.assumingMemoryBound(to: UInt8.self)
            outputBytesSize = size
        }
        memcpy(outputBytes!+outputBytesStart+outputBytesLength, bytes, length)
        outputBytesLength += length
    }
    
    func readResponse() throws {
        let end : [UInt8] = [ 0x0D, 0x0A, 0x0D, 0x0A ]
        let ptr = memmem(inputBytes!+inputBytesStart, inputBytesLength, end, 4)
        if ptr == nil {
            throw WebSocketError.needMoreInput
        }
        let buffer = inputBytes!+inputBytesStart
        let bufferCount = ptr!.assumingMemoryBound(to: UInt8.self)-(inputBytes!+inputBytesStart)
        let string = NSString(bytesNoCopy: buffer, length: bufferCount, encoding: String.Encoding.utf8.rawValue, freeWhenDone: false) as String?
        if string == nil {
            throw WebSocketError.invalidHeader
        }
        let header = string!
        var serverMaxWindowBits = 15
        let clientMaxWindowBits = 15
        var key = ""
        let trim : (String)->(String) = { (text) in return text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)}
        let eqval : (String,String)->(String) = { (line, del) in return trim(line.components(separatedBy: del)[1]) }
        let lines = header.components(separatedBy: "\r\n")
        for i in 0 ..< lines.count {
            let line = trim(lines[i])
            if i == 0  {
                if !line.hasPrefix("HTTP/1.1 101"){
                    throw WebSocketError.invalidResponse(line)
                }
            } else if line != "" {
                var value = ""
                if line.hasPrefix("\t") || line.hasPrefix(" ") {
                    value = trim(line)
                } else {
                    key = ""
                    if let r = line.range(of: ":") {
                        key = trim(line.substring(to: r.lowerBound))
                        value = trim(line.substring(from: r.upperBound))
                    }
                }
                
               
            }
        }
       
        inputBytesLength -= bufferCount+4
        if inputBytesLength == 0 {
            inputBytesStart = 0
        } else {
            inputBytesStart += bufferCount+4
        }
    }
    
    static func ==(lhs: InnerWebSocket, rhs: InnerWebSocket) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
   
    
    var dirty : Bool {
        lock()
        defer { unlock() }
        if exit {
            return false
        }
        if connectionTimeout {
            return true
        }
        if stage != .readResponse && stage != .handleFrames {
            return true
        }
        if rd.streamStatus == .opening && wr.streamStatus == .opening {
            return false;
        }
        if rd.streamStatus != .open || wr.streamStatus != .open {
            return true
        }
        if rd.streamError != nil || wr.streamError != nil {
            return true
        }
        if rd.hasBytesAvailable || frames.count > 0 || inputBytesLength > 0 {
            return true
        }
        if outputBytesLength > 0 && wr.hasSpaceAvailable{
            return true
        }
        return false
    }
    
    func step(){
        if exit {
            return
        }
        do {
            try stepBuffers(more)
            try stepStreamErrors()
            more = false
            switch stage {
            case .openConn:
                try openConn()
                stage = .readResponse
            case .readResponse:
                try readResponse()
                privateReadyState = .open
                fire {
                    self.event.open()
                    self.eventDelegate?.webSocketOpen()
                }
                stage = .handleFrames
            case .handleFrames:
                try stepOutputFrames()
                if closeFinal {
                    privateReadyState = .closing
                    stage = .closeConn
                    return
                }
                let frame = try readFrame()
                switch frame.code {
                case .text:
                    fire {
                        self.event.message(frame.utf8.text)
                        self.eventDelegate?.webSocketMessageText?(frame.utf8.text)
                    }
                case .binary:
                    fire {
                        switch self.binaryType {
                        case .uInt8Array:
                            self.event.message(frame.payload.array)
                        case .nsData:
                            self.event.message(frame.payload.nsdata)
                            // The WebSocketDelegate is necessary to add Objective-C compability and it is only possible to send binary data with NSData.
                            self.eventDelegate?.webSocketMessageData?(frame.payload.nsdata)
                        case .uInt8UnsafeBufferPointer:
                            self.event.message(frame.payload.buffer)
                        }
                    }
                case .ping:
                    let nframe = frame.copy()
                    nframe.code = .pong
                    lock()
                    frames += [nframe]
                    unlock()
                case .pong:
                    fire {
                        switch self.binaryType {
                        case .uInt8Array:
                            self.event.pong(frame.payload.array)
                        case .nsData:
                            self.event.pong(frame.payload.nsdata)
                        case .uInt8UnsafeBufferPointer:
                            self.event.pong(frame.payload.buffer)
                        }
                        self.eventDelegate?.webSocketPong?()
                    }
                case .close:
                    lock()
                    frames += [frame]
                    unlock()
                default:
                    break
                }
            case .closeConn:
                if let error = finalError {
                    self.event.error(error)
                    self.eventDelegate?.webSocketError(error as NSError)
                }
                privateReadyState = .closed
                if rd != nil {
                    closeConn()
                    fire {
                        self.eclose()
                        self.event.close(Int(self.closeCode), self.closeReason, self.closeFinal)
                        self.eventDelegate?.webSocketClose(Int(self.closeCode), reason: self.closeReason, wasClean: self.closeFinal)
                    }
                }
                stage = .end
            case .end:
                fire {
                    self.event.end(Int(self.closeCode), self.closeReason, self.closeClean, self.finalError)
                    self.eventDelegate?.webSocketEnd?(Int(self.closeCode), reason: self.closeReason, wasClean: self.closeClean, error: self.finalError as NSError?)
                }
                exit = true
                manager.remove(self)
            }
        } catch WebSocketError.needMoreInput {
            more = true
        } catch {
            if finalError != nil {
                return
            }
            finalError = error
            if stage == .openConn || stage == .readResponse {
                stage = .closeConn
            } else {
                var frame : Frame?
                if let error = error as? WebSocketError{
                    switch error {
                    case .network(let details):
                        if details == atEndDetails{
                            stage = .closeConn
                            frame = Frame.makeClose(1006, reason: "Abnormal Closure")
                            atEnd = true
                            finalError = nil
                        }
                    case .protocolError:
                        frame = Frame.makeClose(1002, reason: "Protocol error")
                    case .payloadError:
                        frame = Frame.makeClose(1007, reason: "Payload error")
                    default:
                        break
                    }
                }
                if frame == nil {
                    frame = Frame.makeClose(1006, reason: "Abnormal Closure")
                }
                if let frame = frame {
                    if frame.statusCode == 1007 {
                        self.lock()
                        self.frames = [frame]
                        self.unlock()
                        manager.signal()
                    } else {
                        manager.queue.asyncAfter(deadline: DispatchTime.now() + Double(0) / Double(NSEC_PER_SEC)){
                            self.lock()
                            self.frames += [frame]
                            self.unlock()
                            self.manager.signal()
                        }
                    }
                }
            }
        }
    }
    func stepBuffers(_ more: Bool) throws {
        if rd != nil {
            if stage != .closeConn && rd.streamStatus == Stream.Status.atEnd  {
                if atEnd {
                    return;
                }
                throw WebSocketError.network(atEndDetails)
            }
            if more {
                while rd.hasBytesAvailable {
                    var size = inputBytesSize
                    while size-(inputBytesStart+inputBytesLength) < windowBufferSize {
                        size *= 2
                    }
                    if size > inputBytesSize {
                        let ptr = realloc(inputBytes, size)
                        if ptr == nil {
                            throw WebSocketError.memory
                        }
                        inputBytes = ptr?.assumingMemoryBound(to: UInt8.self)
                        inputBytesSize = size
                    }
                    let n = rd.read(inputBytes!+inputBytesStart+inputBytesLength, maxLength: inputBytesSize-inputBytesStart-inputBytesLength)
                    if n > 0 {
                        inputBytesLength += n
                    }
                }
            }
        }
        if wr != nil && wr.hasSpaceAvailable && outputBytesLength > 0 {
            let n = wr.write(outputBytes!+outputBytesStart, maxLength: outputBytesLength)
            if n > 0 {
                outputBytesLength -= n
                if outputBytesLength == 0 {
                    outputBytesStart = 0
                } else {
                    outputBytesStart += n
                }
            }
        }
    }
    func stepStreamErrors() throws {
        if finalError == nil {
            if connectionTimeout {
                throw WebSocketError.network(timeoutDetails)
            }
            if let error = rd?.streamError {
                throw WebSocketError.network(error.localizedDescription)
            }
            if let error = wr?.streamError {
                throw WebSocketError.network(error.localizedDescription)
            }
        }
    }
    func stepOutputFrames() throws {
        lock()
        defer {
            frames = []
            unlock()
        }
        if !closeFinal {
            for frame in frames {
                try writeFrame(frame)
                if frame.code == .close {
                    closeCode = frame.statusCode
                    closeReason = frame.utf8.text
                    closeFinal = true
                    return
                }
            }
        }
    }
    @inline(__always) func fire(_ block: ()->()){
        if let queue = eventQueue {
            queue.sync {
                block()
            }
        } else {
            block()
        }
    }
    
    func writeFrame(_ f : Frame) throws {
        if !f.finished{
            throw WebSocketError.libraryError("cannot send unfinished frames")
        }
        var hlen = 0
        let b : UInt8 = 0x80
        
        head[hlen] = b | f.code.rawValue
        hlen += 1
        var payloadBytes : [UInt8]
        var payloadLen = 0
        if f.utf8.text != "" {
            payloadBytes = UTF8.bytes(f.utf8.text)
        } else {
            payloadBytes = f.payload.array
        }
        payloadLen += payloadBytes.count
       
        var usingStatusCode = false
        if f.statusCode != 0 && payloadLen != 0 {
            payloadLen += 2
            usingStatusCode = true
        }
        if payloadLen < 126 {
            head[hlen] = 0x80 | UInt8(payloadLen)
            hlen += 1
        } else if payloadLen <= 0xFFFF {
            head[hlen] = 0x80 | 126
            hlen += 1
            var i = 1
            while i >= 0 {
                head[hlen] = UInt8((UInt16(payloadLen) >> UInt16(i*8)) & 0xFF)
                hlen += 1
                i -= 1
            }
        } else {
            head[hlen] = UInt8((0x1 << 7) + 127)
            hlen += 1
            var i = 7
            while i >= 0 {
                head[hlen] = UInt8((UInt64(payloadLen) >> UInt64(i*8)) & 0xFF)
                hlen += 1
                i -= 1
            }
        }
        let r = arc4random()
        var maskBytes : [UInt8] = [UInt8(r >> 0 & 0xFF), UInt8(r >> 8 & 0xFF), UInt8(r >> 16 & 0xFF), UInt8(r >> 24 & 0xFF)]
        for i in 0 ..< 4 {
            head[hlen] = maskBytes[i]
            hlen += 1
        }
        if payloadLen > 0 {
            if usingStatusCode {
                var sc = [UInt8(f.statusCode >> 8 & 0xFF), UInt8(f.statusCode >> 0 & 0xFF)]
                for i in 0 ..< 2 {
                    sc[i] ^= maskBytes[i % 4]
                }
                head[hlen] = sc[0]
                hlen += 1
                head[hlen] = sc[1]
                hlen += 1
                for i in 2 ..< payloadLen {
                    payloadBytes[i-2] ^= maskBytes[i % 4]
                }
            } else {
                for i in 0 ..< payloadLen {
                    payloadBytes[i] ^= maskBytes[i % 4]
                }
            }
        }
        try write(head, length: hlen)
        try write(payloadBytes, length: payloadBytes.count)
    }
    func close(_ code : Int = 1000, reason : String = "Normal Closure") {
        let f = Frame()
        f.code = .close
        f.statusCode = UInt16(truncatingIfNeeded: code)
        f.utf8.text = reason
        sendFrame(f)
    }
    func sendFrame(_ f : Frame) {
        lock()
        frames += [f]
        unlock()
        manager.signal()
    }
    func send(_ message : Any) {
        let f = Frame()
        if let message = message as? String {
            f.code = .text
            f.utf8.text = message
        } else if let message = message as? [UInt8] {
            f.code = .binary
            f.payload.array = message
        } else if let message = message as? UnsafeBufferPointer<UInt8> {
            f.code = .binary
            f.payload.append(message.baseAddress!, length: message.count)
        } else if let message = message as? Data {
            f.code = .binary
            f.payload.nsdata = message
        } else {
            f.code = .text
            f.utf8.text = "\(message)"
        }
        sendFrame(f)
    }
    func ping() {
        let f = Frame()
        f.code = .ping
        sendFrame(f)
    }
    func ping(_ message : Any){
        let f = Frame()
        f.code = .ping
        if let message = message as? String {
            f.payload.array = UTF8.bytes(message)
        } else if let message = message as? [UInt8] {
            f.payload.array = message
        } else if let message = message as? UnsafeBufferPointer<UInt8> {
            f.payload.append(message.baseAddress!, length: message.count)
        } else if let message = message as? Data {
            f.payload.nsdata = message
        } else {
            f.utf8.text = "\(message)"
        }
        sendFrame(f)
    }
    
    
    func readFrame() throws -> Frame {
        var frame : Frame
        var finished : Bool
        if !readStateSaved {
            if leaderFrame != nil {
                frame = leaderFrame!
                finished = false
                leaderFrame = nil
            } else {
                frame = try readFrameFragment(nil)
                finished = frame.finished
            }
            if frame.code == .continue{
                throw WebSocketError.protocolError("leader frame cannot be a continue frame")
            }
            if !finished {
                readStateSaved = true
                readStateFrame = frame
                readStateFinished = finished
                throw WebSocketError.needMoreInput
            }
        } else {
            frame = readStateFrame!
            finished = readStateFinished
            if !finished {
                let cf = try readFrameFragment(frame)
                finished = cf.finished
                if cf.code != .continue {
                    if !cf.code.isControl {
                        throw WebSocketError.protocolError("only ping frames can be interlaced with fragments")
                    }
                    leaderFrame = frame
                    return cf
                }
                if !finished {
                    readStateSaved = true
                    readStateFrame = frame
                    readStateFinished = finished
                    throw WebSocketError.needMoreInput
                }
            }
        }
        if !frame.utf8.completed {
            throw WebSocketError.payloadError("incomplete utf8")
        }
        readStateSaved = false
        readStateFrame = nil
        readStateFinished = false
        return frame
    }
    
    func readFrameFragment(_ leader : Frame?) throws -> Frame {
        var len : Int
        var fin = false
        var code : OpCode
        var leaderCode : OpCode
        var utf8 : UTF8
        var payload : Payload
        var statusCode : UInt16
        var headerLen : Int
        var leader = leader
        
        let reader = ByteReader(bytes: inputBytes!+inputBytesStart, length: inputBytesLength)
        if fragStateSaved {
            // load state
            reader.position += fragStatePosition
            len = fragStateLen
            fin = fragStateFin
            code = fragStateCode
            leaderCode = fragStateLeaderCode
            utf8 = fragStateUTF8
            payload = fragStatePayload
            statusCode = fragStateStatusCode
            headerLen = fragStateHeaderLen
            fragStateSaved = false
        } else {
            var b = try reader.readByte()
            fin = b >> 7 & 0x1 == 0x1
            let rsv1 = b >> 6 & 0x1 == 0x1
            let rsv2 = b >> 5 & 0x1 == 0x1
            let rsv3 = b >> 4 & 0x1 == 0x1
            if rsv1 || rsv2 || rsv3 {
                throw WebSocketError.protocolError("invalid extension")
            }
            code = OpCode.binary
            if let c = OpCode(rawValue: (b & 0xF)){
                code = c
            } else {
                throw WebSocketError.protocolError("invalid opcode")
            }
            if !fin && code.isControl {
                throw WebSocketError.protocolError("unfinished control frame")
            }
            b = try reader.readByte()
            if b >> 7 & 0x1 == 0x1 {
                throw WebSocketError.protocolError("server sent masked frame")
            }
            var len64 = Int64(b & 0x7F)
            var bcount = 0
            if b & 0x7F == 126 {
                bcount = 2
            } else if len64 == 127 {
                bcount = 8
            }
            if bcount != 0 {
                if code.isControl {
                    throw WebSocketError.protocolError("invalid payload size for control frame")
                }
                len64 = 0
                var i = bcount-1
                while i >= 0 {
                    b = try reader.readByte()
                    len64 += Int64(b) << Int64(i*8)
                    i -= 1
                }
            }
            len = Int(len64)
            if code == .continue {
                if code.isControl {
                    throw WebSocketError.protocolError("control frame cannot have the 'continue' opcode")
                }
                if leader == nil {
                    throw WebSocketError.protocolError("continue frame is missing it's leader")
                }
            }
            if code.isControl {
                if leader != nil {
                    leader = nil
                }
                
            }
            statusCode = 0
            if leader != nil {
                leaderCode = leader!.code
                utf8 = leader!.utf8
                payload = leader!.payload
            } else {
                leaderCode = code
                utf8 = UTF8()
                payload = reusedPayload
                payload.count = 0
            }
            if leaderCode == .close {
                if len == 1 {
                    throw WebSocketError.protocolError("invalid payload size for close frame")
                }
                if len >= 2 {
                    let b1 = try reader.readByte()
                    let b2 = try reader.readByte()
                    statusCode = (UInt16(b1) << 8) + UInt16(b2)
                    len -= 2
                    if statusCode < 1000 || statusCode > 4999  || (statusCode >= 1004 && statusCode <= 1006) || (statusCode >= 1012 && statusCode <= 2999) {
                        throw WebSocketError.protocolError("invalid status code for close frame")
                    }
                }
            }
            headerLen = reader.position
        }
        
        let rlen : Int
        let rfin : Bool
        let chopped : Bool
        if reader.length+reader.position-headerLen < len {
            rlen = reader.length
            rfin = false
            chopped = true
        } else {
            rlen = len-reader.position+headerLen
            rfin = fin
            chopped = false
        }
        let bytes : UnsafeMutablePointer<UInt8>
        let bytesLen : Int
        
        (bytes, bytesLen) = (UnsafeMutablePointer<UInt8>.init(mutating: reader.bytes), rlen)
        
        reader.bytes += rlen
        
        if leaderCode == .text || leaderCode == .close {
            try utf8.append(bytes, length: bytesLen)
        } else {
            payload.append(bytes, length: bytesLen)
        }
        
        if chopped {
            // save state
            fragStateHeaderLen = headerLen
            fragStateStatusCode = statusCode
            fragStatePayload = payload
            fragStateUTF8 = utf8
            fragStateLeaderCode = leaderCode
            fragStateCode = code
            fragStateFin = fin
            fragStateLen = len
            fragStatePosition = reader.position
            fragStateSaved = true
            throw WebSocketError.needMoreInput
        }
        
        inputBytesLength -= reader.position
        if inputBytesLength == 0 {
            inputBytesStart = 0
        } else {
            inputBytesStart += reader.position
        }
        
        let f = Frame()
        (f.code, f.payload, f.utf8, f.statusCode, f.finished) = (code, payload, utf8, statusCode, fin)
        return f
    }
    
}
