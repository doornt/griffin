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
        
        lifeCycleCallback("viewDidLoad")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lifeCycleCallback("viewWillAppear")
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lifeCycleCallback("viewDidAppear")
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lifeCycleCallback("viewDidDisappear")
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        lifeCycleCallback("viewWillLayoutSubviews")
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lifeCycleCallback("viewDidLayoutSubviews")
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        lifeCycleCallback("didReceiveMemoryWarning")
    }
    
    func lifeCycleCallback(_ lifeCycle: String) {
        guard let lifeCycleDict = self.rootView?.lifeCycleDict  else {
            return
        }
        lifeCycleDict[lifeCycle]?.callWithoutArguments()
    }
}
