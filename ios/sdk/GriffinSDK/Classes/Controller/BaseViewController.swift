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
    
    private var _rootView: UIView?
    var rootView: UIView? {
        get {
            return _rootView
        }
        set {
            _rootView = newValue
            self.view.addSubview(newValue!)
        }
    }

    
    var sourceUrl: String?
//    private var gnView: UIView = UIView()
//
//    private var _controllerHost: ControllerHost?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(sourceUrl: String) {
        super.init(nibName: nil, bundle: nil)
        self.sourceUrl = sourceUrl
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _renderWithURL(_ url: String) {
//        _controllerHost?.destroy()
//
//        _controllerHost = ControllerHost.init()
//        _controllerHost?.vc = self
//        _controllerHost?.pageName = url
//
//        _controllerHost?.renderWithURL(urlString: url)
//
//        _controllerHost?.onCreate = {
//            [weak self](view) in
//            self?.gnView.removeFromSuperview()
//            self?.gnView = view
//            self?.view.addSubview((self?.gnView)!)
//        }
//
//        _controllerHost?.onFailed = {
//            (error) in
//        }
//
//        _controllerHost?.onRenderFinish = {
//            (view) in
//        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        guard let url = self.sourceUrl else {
//            return
//        }
//        _renderWithURL(url)
        
//        _controllerHost?.dispatchVCLifeCycle2Js(ViewControllerLifeCycle.ViewDidLoad.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
//        _controllerHost?.dispatchVCLifeCycle2Js(ViewControllerLifeCycle.ViewWillAppear.rawValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//         _controllerHost?.dispatchVCLifeCycle2Js(ViewControllerLifeCycle.viewDidAppear.rawValue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
//         _controllerHost?.dispatchVCLifeCycle2Js(ViewControllerLifeCycle.ViewWillDisappear.rawValue)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
//         _controllerHost?.dispatchVCLifeCycle2Js(ViewControllerLifeCycle.ViewDidDisappear.rawValue)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        _controllerHost?.dispatchVCLifeCycle2Js(ViewControllerLifeCycle.ViewWillLayoutSubviews.rawValue)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        _controllerHost?.dispatchVCLifeCycle2Js(ViewControllerLifeCycle.ViewDidLayoutSubviews.rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
//        _controllerHost?.dispatchVCLifeCycle2Js(ViewControllerLifeCycle.DidReceiveMemoryWarning.rawValue)
    }
}
