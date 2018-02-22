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
    private var _viewControllers: [UIViewController] = [UIViewController]()
    
    private var _addedComponents: [ViewComponent] = [ViewComponent]()
    var addedComponents: [ViewComponent] {
        return _addedComponents
    }
    func registerAddedComponent(_ component: ViewComponent) {
        _addedComponents.append(component)
    }
    
    
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
    
    func removeChildren(componentRef: String) {
    
    }
    
    func getComponent(rootComponentRef: String, componentRef: String) -> ViewComponent? {
        guard let component = components[rootComponentRef] else {
            return nil
        }
        
        return component[componentRef]
    }
    
    func pop() -> ViewComponent {
        _viewControllers.removeLast()
        _topViewController = _viewControllers.last as? BaseViewController
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
    
    private var _topViewController: BaseViewController?
    var topViewController: BaseViewController? {
        get {
            return _topViewController
        }
        set {
            _topViewController = newValue
            if _stashRootViewId != nil {
                pushViewController(withId: _stashRootViewId!, animated: false)
                _stashRootViewId = nil
            }
        }
    }
    
    private var _stashRootViewId: String?
    
    func pushViewController(withId: String, animated: Bool) {
        
        if _topViewController != nil {
            if _viewControllers.count == 0 {
                _topViewController?.rootView = rootComponents[withId]?.view
                registerAddedComponent(rootComponents[withId]!)
                _viewControllers.append(_topViewController!)
                return
            }
        } else {
            _stashRootViewId = withId
            return
        }
        
        let vc = BaseViewController()
        _viewControllers.append(vc)
        vc.rootView = rootComponents[withId]?.view
        registerAddedComponent(rootComponents[withId]!)
        _topViewController?.navigationController?.pushViewController(vc, animated: animated)
        _topViewController = vc
    }
    
    func popViewController(animated: Bool) {
        
        let _ = pop()
        _topViewController?.navigationController?.popViewController(animated: animated)
    }
    
    static let instance = RootComponentManager()
    private init() {}
}
