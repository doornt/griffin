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
    // MARK: - unload
    func removeAllRootComponents() {
        assert(Thread.current == Thread.main, "removeAllRootComponents should be called in main thread")
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
    
    // MARK: - root controller
    private var _rootController:BaseViewController?
    var rootController: BaseViewController? {
        get {
            assert(Thread.current == Thread.main, "get rootController should be called in main thread")
            return _rootController
        }
        set {
            assert(Thread.current == Thread.main, "set rootController should be called in main thread")
            _rootController = newValue
        }
    }
    
    // MARK: - added component
    private var _addedComponentDic: GnThreadSafeDictionary<String, ViewComponent> = GnThreadSafeDictionary<String, ViewComponent>()
    var addedComponents: [ViewComponent] {
        assert(Thread.current == GnThreadPool.instance.componentThread, "addedComponents should be called in componentThread thread")
        return _addedComponentDic.values
    }
    
    func registerAddedComponent(_ component: ViewComponent) {
        assert(Thread.current == Thread.main, "registerAddedComponent should be called in main thread")
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
        assert(Thread.current == Thread.main, "registerAddedComponent should be called in main thread")
        return _rootComponents.values.map { (r) -> ViewComponent in r.rootComponent}
    }
    
    func pushRootComponent(_ root: ViewComponent) {
        assert(Thread.current == GnThreadPool.instance.componentThread, "addedComponents should be called in componentThread thread")
        _rootComponents[root.ref] = RootComponent.init(rootComponent: root)
        addComponent(rootComponentRef: root.ref, componentRef: root.ref, component: root)
    }
    
    func addComponent(rootComponentRef: String,componentRef: String, component: ViewComponent) {
        assert(Thread.current == GnThreadPool.instance.componentThread, "addedComponents should be called in componentThread thread")
        guard let rComponent = _rootComponents[rootComponentRef] else {
            Log.Error("Cannot find rootcomponent \(rootComponentRef) in _components")
            return
        }
        rComponent.addComponent(componentRef, component: component)
    }
    
    func getComponent(rootComponentRef: String, componentRef: String) -> ViewComponent? {
        assert(Thread.current == GnThreadPool.instance.componentThread, "addedComponents should be called in componentThread thread")
        guard let component = _rootComponents[rootComponentRef] else {
            return nil
        }
        return component.getComponent(componentRef)
    }
    
    // MARK: - topRootComponent
    private var _viewControllers:GnThreadSafeArray<BaseViewController> = GnThreadSafeArray<BaseViewController>()
    
    var topRootComponent: ViewComponent? {
        assert(Thread.current == GnThreadPool.instance.componentThread, "addedComponents should be called in componentThread thread")
        return _viewControllers.last?.rootComponent
    }
    
    var topRootViewId: String? {
        assert(Thread.current == GnThreadPool.instance.componentThread, "addedComponents should be called in componentThread thread")
        return topRootComponent?.ref
    }
    
    var topChildrenComponent: [ViewComponent]? {
        guard let component = _rootComponents[topRootViewId!] else {
            return nil
        }
        return component.allChildrenComponent
    }

    // MARK:- Navigator operation
    func pushViewController(withId: String, animated: Bool) {
        assert(Thread.current == Thread.main, "pushViewController should be called in main thread")
        
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
        
        let vc = BaseViewController()
        push(vc, withRootComponent: rootComponent.rootComponent)
        rootVC.navigationController?.pushViewController(vc, animated: animated)
    }
    
    func popViewController(animated: Bool) {
        assert(Thread.current == Thread.main, "popViewController should be called in main thread")
        guard let rootVC = _rootController else {
            Log.Error("rootController cannot be nil, there must be some fatal error")
            return
        }
        
        rootVC.navigationController?.popViewController(animated: animated)
    }
    
    private func push(_ vc: BaseViewController, withRootComponent rootComponent: ViewComponent) {
        assert(Thread.current == Thread.main, "pop should be called in main thread")
        _viewControllers.append(vc)
        vc.rootView = rootComponent.view
        vc.rootComponent = rootComponent
        registerAddedComponent(rootComponent)
    }
    
    func pop() -> ViewComponent {
        assert(Thread.current == Thread.main, "pop should be called in main thread")
        let rComponent = _rootComponents.removeValue(forKey: topRootViewId!)
        _viewControllers.removeLast()
        return (rComponent?.rootComponent)!
    }
    
    static let instance = RootComponentManager()
    private init() {}
}
