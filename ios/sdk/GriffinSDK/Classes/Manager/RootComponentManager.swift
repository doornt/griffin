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
    
    private var _addedComponentLock: NSLock = NSLock()
    private var _addedComponentDic: [String:ViewComponent] = [String:ViewComponent]()
    var addedComponents: [ViewComponent] {
        _addedComponentLock.lock()
        defer {
            _addedComponentLock.unlock()
        }
        return Array(_addedComponentDic.values)
    }
    
    func registerAddedComponent(_ component: ViewComponent) {
        _addedComponentLock.lock()
        _addedComponentDic[component.ref] = component
        _addedComponentLock.unlock()
    }
    
    func unregisterAddedComponents(_ components: [ViewComponent]) {
        _addedComponentLock.lock()
        
        for c in components {
            _addedComponentDic.removeValue(forKey: c.ref)
        }
        _addedComponentLock.unlock()
    }
    
    
    private var _componentsLock: NSLock = NSLock()
    private var _components: [String:RootComponent] = [String: RootComponent]()
    
    private var _viewControllersLock: NSLock = NSLock()
    private var _viewControllers: [BaseViewController] = [BaseViewController]()
    
    
    var allRootComponents:[ViewComponent] {
        _componentsLock.lock()
        defer {
            _componentsLock.unlock()
        }
        return _components.values.map { (r) -> ViewComponent in r.rootComponent}
    }
    
    func pushRootComponent(_ root: ViewComponent) {
        _componentsLock.lock()
        _components[root.ref] = RootComponent.init(rootComponent: root)
        _componentsLock.unlock()
        addComponent(rootComponentRef: root.ref, componentRef: root.ref, component: root)
    }
    
    func addComponent(rootComponentRef: String,componentRef: String, component: ViewComponent) {
        _componentsLock.lock()
        guard let rComponent = _components[rootComponentRef] else {
            Log.Error("Cannot find rootcomponent \(rootComponentRef) in _components")
            _componentsLock.unlock()
            return
        }
        _componentsLock.unlock()
        rComponent.addComponent(componentRef, component: component)
    }
    
    
    func getComponent(rootComponentRef: String, componentRef: String) -> ViewComponent? {
        _componentsLock.lock()
        guard let component = _components[rootComponentRef] else {
            _componentsLock.unlock()
            return nil
        }
        _componentsLock.unlock()
        return component.getComponent(componentRef)
    }
    
    var topRootComponent: ViewComponent? {
        _viewControllersLock.lock()
        defer {
            _viewControllersLock.unlock()
        }
        return _viewControllers.last?.rootComponent
    }
    
    var topRootViewId: String? {
        return topRootComponent?.ref
    }
    
    var topChildrenComponent: [ViewComponent]? {
        _componentsLock.lock()
        guard let component = _components[topRootViewId!] else {
            _componentsLock.unlock()
            return nil
        }
        _componentsLock.unlock()
        return component.allChildrenComponent
    }
    
    
    func pushViewController(withId: String, animated: Bool) {
        assert(Thread.current == Thread.main, "pushViewController should be called in main thread")
        
        guard let rootVC = _rootController, let rootComponent = _components[withId] else {
            Log.Error("rootController cannot be nil, there must be some fatal error")
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
    
        let _ = pop()
        
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
        _viewControllers.removeLast()
        let rComponent = _components.removeValue(forKey: topRootViewId!)
        return (rComponent?.rootComponent)!
    }
    
    static let instance = RootComponentManager()
    private init() {}
}
