//
//  ViewController.swift
//  Griffin
//
//  Created by 裴韬 on 2017/12/4.
//  Copyright © 2017年 裴韬. All rights reserved.
//

import UIKit
import GriffinSDK
import JavaScriptCore

@objc protocol TestProtocol: JSExport {

    func funcForJSWithoutParam()
    func funcForJSWithParam(param : String)
    func wxPay(orderNo: String)
}


class ViewController: UIViewController {
    
    let context = JSContext()!
    
    lazy var path: String = {
        let tPath = Bundle.main.path(forResource: "index", ofType: "js")
        return tPath!;
    }()
    
    lazy var callJSBtn: UIButton = {
       
        let btn = UIButton.init(frame: CGRect.init(x: 20, y: 64, width: 150, height: 40))
        btn.backgroundColor = UIColor.blue
        btn.setTitle("CallJS", for: .normal)
        btn.addTarget(self, action: #selector(swiftCallJS), for: .touchUpInside)
        return btn
    }()
    
    lazy var jsCallSwiftBtn: UIButton = {
        
        let btn = UIButton.init(frame: CGRect.init(x: 200, y: 64, width: 150, height: 40))
        btn.backgroundColor = UIColor.blue
        btn.setTitle("jsCallSwift", for: .normal)
        btn.addTarget(self, action: #selector(jsCallSwift), for: .touchUpInside)
        return btn
    }()
    
    func test1(a : String) {
        print(a)
    }
    @objc func swiftCallJS() {
        
//        let block : @convention(block) (NSString!) -> Void = {
//            (string : NSString!) -> Void in
//            print("test")
//        }
//
//        context.setObject(unsafeBitCast(block, to: AnyObject.self), forKeyedSubscript: "test" as NSCopying & NSObjectProtocol)
        let simplifyString: @convention(block) (String) -> () = { input in
            print(input)
        }
        context.setObject(unsafeBitCast(simplifyString, to: AnyObject.self), forKeyedSubscript: "simplifyString" as NSCopying & NSObjectProtocol)

        
        let result3 = context.objectForKeyedSubscript("functionForSwift").call(withArguments:([10, 20, test1])).toString()
        print(result3)
    }
    
    @objc func jsCallSwift() {
        context.objectForKeyedSubscript("functionForSwiftWithoutParam").call(withArguments: [])
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(jsCallSwiftBtn)
        view.addSubview(callJSBtn)
        
        context.setObject(self, forKeyedSubscript: "JSCoreBridge" as NSCopying & NSObjectProtocol)
        context.exceptionHandler = {context, exceptionValue in
            print(exceptionValue ?? "")
        }
        
        run()
    }

    func run() {
        do {
            let jsString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            context.evaluateScript(jsString)
        } catch (let error) {
            print("Error while processing script file: \(error)")
        }
    }
    
}

extension ViewController: TestProtocol {
    func funcForJSWithoutParam() {
        print("this is func for js")
    }
    
    func funcForJSWithParam(param: String) {
        print("this is string from \(param)")
    }
    func wxPay(orderNo: String) {
        print(orderNo)
    }
}












