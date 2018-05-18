//
//  RootComponentManager.swift
//  GriffinSDK
//
//  Created by 裴韬 on 2018/2/8.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class RootComponent {
    private var _rootviewId:String
    var rootComponent: ViewComponent
    
    private var _components: GnThreadSafeDictionary<String, ViewComponent> = GnThreadSafeDictionary<String, ViewComponent>()
    
    init(rootComponent: ViewComponent) {
        self._rootviewId = rootComponent.ref
        self.rootComponent = rootComponent
    }
    func addComponent(_ componentRef:String, component: ViewComponent) {
        _components[componentRef] = component
    }
    
    func getComponent(_ componentRef: String) -> ViewComponent? {
        return _components[componentRef]
    }
    
    var allChildrenComponent:[ViewComponent] {
        return _components.values
    }
}

class RootComponentManager {
    // MARK: - root controller
    private var _rootController:BaseViewController?
    var rootController: BaseViewController? {
        get {
            GnThreadPool.AssertMainThread(msg: "get root controller")
            return _rootController
        }
        set {
            GnThreadPool.AssertMainThread(msg: "set root controller")
            _rootController = newValue
        }
    }
    
    // MARK: - added component
    private var _addedComponentDic: GnThreadSafeDictionary<String, ViewComponent> = GnThreadSafeDictionary<String, ViewComponent>()
    var addedComponents: [ViewComponent] {
        GnThreadPool.AssertComponentThread(msg: "addedComponents")
        return _addedComponentDic.values
    }
    
    func registerAddedComponent(_ component: ViewComponent) {
        _addedComponentDic[component.ref] = component
    }
    
    func unregisterAddedComponents(_ components: [ViewComponent]) {
        GnThreadPool.instance.performOnComponentThread {
            if components.count < 1 {
                return
            }
            var keys:[String] = [String]()
            for c in components {
                keys.append(c.ref)
            }
            self._addedComponentDic.removeValueAsync(forKeys: keys)
        }
    }
    
    // MARK: - component
    private var _rootComponents: GnThreadSafeDictionary<String, RootComponent> = GnThreadSafeDictionary<String, RootComponent>()
    
    var allRootComponents:[ViewComponent] {
        GnThreadPool.AssertMainThread(msg: "registerAddedComponent")
        return _rootComponents.values.map { (r) -> ViewComponent in r.rootComponent}
    }
    
    func pushRootComponent(_ root: ViewComponent) {
        GnThreadPool.AssertComponentThread(msg: "pushRootComponent")
        _rootComponents[root.ref] = RootComponent.init(rootComponent: root)
        addComponent(rootComponentRef: root.ref, componentRef: root.ref, component: root)
    }
    
    func addComponent(rootComponentRef: String,componentRef: String, component: ViewComponent) {
        GnThreadPool.AssertComponentThread(msg: "addComponent")
        guard let rComponent = _rootComponents[rootComponentRef] else {
            Log.Error("Cannot find rootcomponent \(rootComponentRef) in _components")
            return
        }
        rComponent.addComponent(componentRef, component: component)
    }
    
    func getComponent(rootComponentRef: String, componentRef: String) -> ViewComponent? {
        GnThreadPool.AssertComponentThread(msg: "getComponent")
        guard let component = _rootComponents[rootComponentRef] else {
            return nil
        }
        return component.getComponent(componentRef)
    }
    
    // MARK: - topRootComponent
    private var _viewControllers:GnThreadSafeArray<BaseViewController> = GnThreadSafeArray<BaseViewController>()
    
    var topRootComponent: ViewComponent? {
        return _viewControllers.last?.rootComponent
    }
    
    var topRootViewId: String? {
        return topRootComponent?.ref
    }
    
    var topChildrenComponent: [ViewComponent]? {
        guard let component = _rootComponents[topRootViewId!] else {
            return nil
        }
        return component.allChildrenComponent
    }

    static let instance = RootComponentManager()
    private init() {}
}

// MARK: - unload
extension RootComponentManager {
    func removeAllRootComponents() {
        GnThreadPool.AssertMainThread(msg: "removeAllRootComponents")
        for rootComponent in RootComponentManager.instance.allRootComponents {
            rootComponent.view.removeFromSuperview()
            rootComponent.removeChildren()
        }
        
        back2RootPage()
    }
    
    private func back2RootPage() {
        let vc: BaseViewController? = _viewControllers.first
        guard let rootVC = vc else {
            return
        }
        _viewControllers.removeAll()
        rootVC.navigationController?.popToRootViewController(animated: false)
    }
}

// MARK:- Navigator operation
extension RootComponentManager {
    
    func pushViewController(withId: String, animated: Bool) {
        GnThreadPool.AssertComponentThread(msg: "pushViewController")
        guard let rootVC = _rootController else {
            Log.Error("rootController cannot be nil")
            return
        }
        guard let rootComponent = _rootComponents[withId] else {
            
            Log.Error("rootComponent cannot be nil, withId\(withId) _rootComponents \(_rootComponents.allKeys())")
            return
        }
        if _viewControllers.count == 0 {
            push(rootVC, withRootComponent: rootComponent.rootComponent)
            return
        }
        
        var vc: BaseViewController? = nil
        GnThreadPool.instance.performOnMainThreadSync {
            vc = BaseViewController()
        }
        guard let rVc = vc else {
            return
        }
        push(rVc, withRootComponent: rootComponent.rootComponent)
        
        GnThreadPool.instance.performOnMainThread {
            rootVC.navigationController?.pushViewController(rVc, animated: animated)
        }
    }
    
    func popViewController(animated: Bool) {
        GnThreadPool.AssertComponentThread(msg: "popViewController")

        guard let rootVC = _rootController else {
            Log.Error("rootController cannot be nil, there must be some fatal error")
            return
        }
        
        if _viewControllers.count < 2 { // safe guard
            return
        }
        GnThreadPool.instance.performOnMainThread {
            rootVC.navigationController?.popViewController(animated: animated)
        }
    }
    
    private func push(_ vc: BaseViewController, withRootComponent rootComponent: ViewComponent) {
        GnThreadPool.AssertComponentThread(msg: "push")
        _viewControllers.append(vc)
        vc.rootComponent = rootComponent
        registerAddedComponent(rootComponent)
        GnThreadPool.instance.performOnMainThread {
            vc.rootView = rootComponent.view
        }
    }
    
    func pop() -> ViewComponent {
        GnThreadPool.AssertComponentThread(msg: "pop")
        let rComponent = _rootComponents.removeValue(forKey: topRootViewId!)
        _viewControllers.removeLast()
        return (rComponent?.rootComponent)!
    }
}
