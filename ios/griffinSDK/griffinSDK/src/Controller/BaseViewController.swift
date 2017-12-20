//
//  BaseViewController.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/3.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit


public class BaseViewController : UIViewController,UIGestureRecognizerDelegate{
    
    var sourceUrl:NSURL?
    
    convenience init(url:NSURL){
        self.init(nibName:nil,bundle:nil)
        
        self.sourceUrl = url
    }
    
    private func renderWithUrl(){
        if sourceUrl == nil{
            return
        }
        if let jsSourcePath = Bundle.main.path(forResource: "js-bundle", ofType: "js"){
            do{
                let jsSourceContents = try String(contentsOfFile:jsSourcePath)
                JSCoreBridge.instance.executeJavascript(script: jsSourceContents)
            }
        }
    }
    
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.renderWithUrl()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
