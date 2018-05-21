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
    
    var rootComponent: ViewComponent?
    
    private var _rootView: UIView?
    var rootView: UIView? {
        get {
            return _rootView
        }
        set {
            _rootView?.removeFromSuperview()
            _rootView = newValue
            self.view.addSubview(newValue!)
        }
    }
    
    var sourceUrl: String?

    var tableView = ListView.init(frame: CGRect.init(x: 0, y: 0, width: Environment.instance.screenWidth, height: Environment.instance.screenHeight))
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {} else { self.automaticallyAdjustsScrollViewInsets = false }
        
        self.view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
