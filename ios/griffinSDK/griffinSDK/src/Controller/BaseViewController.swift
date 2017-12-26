//
//  BaseViewController.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/3.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit


public class BaseViewController : UIViewController,UIGestureRecognizerDelegate{
    
    var rootView: View?
    var sourceUrl:URL?
    
    func setRootView(_ view: View) {
        self.rootView = view
        self.view.addSubview(self.rootView!)
    }
    
    convenience init(url:URL?){
        self.init(nibName:nil,bundle:nil)
        
        self.sourceUrl = url
    }
    
    private func renderWithUrl(){
        if sourceUrl == nil{
            return
        }
        if FileManager.default.fileExists(atPath:sourceUrl!.path){
            do{
                let jsSourceContents = try String(contentsOfFile:sourceUrl!.path)
                let _ = JSCoreBridge.instance.executeJavascript(script: jsSourceContents)
            }
            catch{
                print(error.localizedDescription)
            }
           
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.renderWithUrl()
        
        JSCoreBridge.instance.callJsMethod(method: "dispatchEventToJs", args: [self.rootView?.instanceId ?? "", "viewDidLoad"])
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JSCoreBridge.instance.callJsMethod(method: "dispatchEventToJs", args: [self.rootView?.instanceId ?? "", "viewWillAppear"])
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        JSCoreBridge.instance.callJsMethod(method: "dispatchEventToJs", args: [self.rootView?.instanceId ?? "", "viewDidAppear"])
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        JSCoreBridge.instance.callJsMethod(method: "dispatchEventToJs", args: [self.rootView?.instanceId ?? "", "viewDidDisappear"])
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        JSCoreBridge.instance.callJsMethod(method: "dispatchEventToJs", args: [self.rootView?.instanceId ?? "", "viewWillLayoutSubviews"])
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        JSCoreBridge.instance.callJsMethod(method: "dispatchEventToJs", args: [self.rootView?.instanceId ?? "", "viewDidLayoutSubviews"])
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        JSCoreBridge.instance.callJsMethod(method: "dispatchEventToJs", args: [self.rootView?.instanceId ?? "", "didReceiveMemoryWarning"])
    }
}
