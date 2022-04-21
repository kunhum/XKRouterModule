//
//  XKRouter.swift
//  XKRouterModule
//
//  Created by kenneth on 2022/4/20.
//

import UIKit

public class XKRouter: NSObject {
    
    struct RouterInfo {
        let target: NSObject.Type
        let selector: Selector
    }
    
    static var routerDictionary: [String: RouterInfo] = [:]
}

public extension XKRouter {
    
    
    /// 注册
    /// - Parameters:
    ///   - scheme: 唯一标识
    ///   - target: target eg：SwiftClass.self OCClass.class
    ///   - selector: 可供target调用的selector
    @objc class func register(scheme: String, target: NSObject.Type, selector: Selector) {
        let router = RouterInfo(target: target, selector: selector)
        routerDictionary[scheme] = router
    }
    
    /// 路由方法
    /// - Parameters:
    ///   - scheme: 唯一标识
    ///   - params: 参数
    /// - Returns: 返回值
    class func invoke(scheme: String, params: [String: Any]?) -> Any? {
        guard let router = routerDictionary[scheme] else {
            debugPrint("scheme未注册")
            return nil
        }
        guard router.target.responds(to: router.selector) else {
            debugPrint("target未找到selector")
            return nil
        }
        let result = router.target.perform(router.selector, with: params)
        return result?.takeUnretainedValue()
    }
}
