//
//  BaseViewController.swift
//  GriffinSDK
//
//  Created by sampson on 2017/12/3.
//  Copyright © 2017年 com.doornt. All rights reserved.
//

import UIKit

enum ViewControllerLifeCycle: String {
    case ViewDidLoad
    case ViewWillAppear
    case viewDidAppear
    case ViewWillDisappear
    case ViewDidDisappear
    case ViewWillLayoutSubviews
    case ViewDidLayoutSubviews
    case DidReceiveMemoryWarning
}

class BaseViewController : UIViewController {
    
    private var rootView: UIView?
    private var sourceUrl:URL?
    
    func setRootView(_ view: UIView) {
        Log.LogInfo("Init rootview \(view)")
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

//        let urlString = "http://api.ffan.com/travelHotel/v1/getRecommendBanner"
//        NetworkManager.instance.get(url: urlString, params: ["InterfaceVersion":"2"], completionHandler: {
//            (data, error) in
//            print(data ?? "")
//        })
        
//        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 64, width: 100, height: 100))
//        self.view .addSubview(imageView)
//        imageView.backgroundColor = .red
//        imageView.setGriffinImage(with: "https://op.meituan.net/oppkit_pic/2ndfloor_portal_headpic/157e291c008894a2db841f0dda0d64c.png")

//        let home = NSHomeDirectory()
//        let cache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
//        print("\n home: \(home) cache: \(cache)")

        
        dispatchVCLifeCycle2Js(period: ViewControllerLifeCycle.ViewDidLoad.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dispatchVCLifeCycle2Js(period: ViewControllerLifeCycle.ViewWillAppear.rawValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dispatchVCLifeCycle2Js(period: ViewControllerLifeCycle.viewDidAppear.rawValue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dispatchVCLifeCycle2Js(period: ViewControllerLifeCycle.ViewWillDisappear.rawValue)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dispatchVCLifeCycle2Js(period: ViewControllerLifeCycle.ViewDidDisappear.rawValue)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        dispatchVCLifeCycle2Js(period: ViewControllerLifeCycle.ViewWillLayoutSubviews.rawValue)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dispatchVCLifeCycle2Js(period: ViewControllerLifeCycle.ViewDidLayoutSubviews.rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        dispatchVCLifeCycle2Js(period: ViewControllerLifeCycle.DidReceiveMemoryWarning.rawValue)
    }
    
    private func dispatchVCLifeCycle2Js(period: String) {
//        JSCoreBridge.instance.dispatchEventToJs(rootviewId: rootView?.instanceId ?? "", data: ["type": period])
    }
}
