//
//  BaseViewController.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/3.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit


class BaseViewController : UIViewController {
    
    private var rootView: View?
    private var sourceUrl:URL?
    
    func setRootView(_ view: View) {
        self.rootView = view
        self.view.addSubview(self.rootView!)
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
    
    convenience init(url:URL?){
        self.init(nibName:nil,bundle:nil)
        
        self.sourceUrl = url
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.renderWithUrl()
        
        JSCoreBridge.instance.callJs(method: "dispatchEventToJs", args: [self.rootView?.instanceId ?? "", "viewDidLoad"])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JSCoreBridge.instance.callJs(method: "dispatchEventToJs", args: [self.rootView?.instanceId ?? "", "viewWillAppear"])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        JSCoreBridge.instance.callJs(method: "dispatchEventToJs", args: [self.rootView?.instanceId ?? "", "viewDidAppear"])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        JSCoreBridge.instance.callJs(method: "dispatchEventToJs", args: [self.rootView?.instanceId ?? "", "viewDidDisappear"])
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        JSCoreBridge.instance.callJs(method: "dispatchEventToJs", args: [self.rootView?.instanceId ?? "", "viewWillLayoutSubviews"])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        JSCoreBridge.instance.callJs(method: "dispatchEventToJs", args: [self.rootView?.instanceId ?? "", "viewDidLayoutSubviews"])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        JSCoreBridge.instance.callJs(method: "dispatchEventToJs", args: [self.rootView?.instanceId ?? "", "didReceiveMemoryWarning"])
    }
}
