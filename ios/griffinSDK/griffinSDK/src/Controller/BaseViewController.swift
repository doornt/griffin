//
//  BaseViewController.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/3.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit


public class BaseViewController : UIViewController,UIGestureRecognizerDelegate{
    
    var sourceUrl:URL?
    
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
                JSCoreBridge.instance.executeJavascript(script: jsSourceContents)
            }
            catch{
                print(error.localizedDescription)
            }
           
        }
    
    }
    
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
        self.renderWithUrl()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
