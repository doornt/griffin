//
//  RootComponentManager.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/2/8.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class RootComponentManager {
    
    private var rootComponentsId:[String] = [String]()
    private var rootComponents: [String:ViewComponent] = [String:ViewComponent]()
    
    private var components: [String:[String: ViewComponent]] = [String: [String:ViewComponent]]()
    
    var allRootComponents:[ViewComponent] {
        return Array(rootComponents.values)
    }
    
    func pushRootComponent(_ root: ViewComponent) {
        rootComponentsId.append(root.ref)
        rootComponents[root.ref] = root
    }
    
    func addComponent(rootComponentRef: String,componentRef: String, component: ViewComponent) {
        if components[rootComponentRef] == nil {
            var componentDic = [String:ViewComponent]()
            componentDic[componentRef] = component
            components[rootComponentRef] = componentDic
        } else {
            components[rootComponentRef]![componentRef] = component
        }
    }
    
    func getComponent(rootComponentRef: String, componentRef: String) -> ViewComponent? {
        guard let component = components[rootComponentRef] else {
            return nil
        }
        
        return component[componentRef]
    }
    
    func pop() -> ViewComponent {
        components.removeValue(forKey: rootComponentsId.last!)
        return rootComponents.removeValue(forKey: rootComponentsId.removeLast())!
    }
    
    var topComponent: ViewComponent? {
        guard let id = rootComponentsId.last else {
            return nil
        }
        return rootComponents[id]
    }
    
    var topChildrenComponent: [ViewComponent]? {
        guard let id = rootComponentsId.last, let componentDic = components[id] else {
            return nil
        }
        return Array(componentDic.values)
    }
    
    private var _topViewController: UIViewController?
    var topViewController: UIViewController? {
        get {
            return _topViewController
        }
        set {
            _topViewController = newValue
        }
    }
    
    func pushViewController(withId: String, animated: Bool) {
        let vc = BaseViewController()
        vc.rootView = rootComponents[withId]?.view
        _topViewController = vc
        _topViewController?.navigationController?.pushViewController(vc, animated: animated)
    }
    
    func popViewController(animated: Bool) {
        
        let _ = pop()
        _topViewController?.navigationController?.popViewController(animated: animated)
    }
    
    static let instance = RootComponentManager()
    private init() {}
}
