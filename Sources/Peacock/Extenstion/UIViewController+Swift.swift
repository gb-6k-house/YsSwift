/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/


import Foundation
import UIKit
import YsSwift



public extension YSSwift where Base: UIViewController {

   public func push(_ vc: UIViewController, animated: Bool = true, withdata:Any? = nil) {
        // 此处navigation可能为空
        // log.debug("TopViewC ontroller.navigation \(self.base.navigationController)")
        if let ysVC = vc as? YSBaseViewController {
            ysVC.beforePush(withdata)
        }
        
        self.base.navigationController?.pushViewController(vc, animated: animated)
    }

   public func replace(_ vc: UIViewController, animated: Bool = true) {
        if var viewControllers = self.base.navigationController?.viewControllers {
            viewControllers.removeLast()
            viewControllers.append(vc)
            self.base.navigationController?.setViewControllers(viewControllers, animated: animated)
        }
    }

   public func pop(_ vc: UIViewController? = nil, animated: Bool = true, withdata: Any? = nil) {
        if let vc = vc {
            if let ysVC = vc as? YSBaseViewController {
                ysVC.beforePopNext(withdata)
            }
            _ = self.base.navigationController?.popToViewController(vc, animated: animated)
        } else {
            if let vcs = self.base.navigationController?.viewControllers, vcs.count > 1,
                 let ysVC = vcs[vcs.count-2] as? YSBaseViewController{
                ysVC.beforePopNext(withdata)
            }
            _ = self.base.navigationController?.popViewController(animated: animated)
        }
    }
    
    public func pop(of aClass: Swift.AnyClass, animated: Bool = true, withdata: Any? = nil) {
        self.pop(self.findController(of: aClass), animated: animated, withdata: withdata)
    }
    
    public func findController(of aClass: Swift.AnyClass) -> UIViewController? {
        guard let nav = self.base.navigationController else {
            return nil
        }
        
        for i in 0..<nav.viewControllers.count {
            let vc = nav.viewControllers[i]
            if vc.isKind(of: aClass) {
                return vc
            }
        }
        return nil
    }

   public func popToRoot(_ animated: Bool = true) {
        _ = self.base.navigationController?.popToRootViewController(animated: animated)
    }

   public func present(_ vc: UIViewController, animated: Bool = true, withdata:Any? = nil, completion: (() -> Void)? = nil) {
    if let nav = vc as? UINavigationController, let ysVC = nav.topViewController as? YSBaseViewController {
        ysVC.beforePush(withdata)
    }else if let ysVC = vc as? YSBaseViewController {
        ysVC.beforePush(withdata)
    }

        self.base.present(vc, animated: animated, completion: completion)
    }

   public func dismiss(_ animated: Bool = true, completion: (() -> Void)? = nil) {
        self.base.dismiss(animated: animated, completion: completion)
    }

   public var topViewController: UIViewController {
        get {

            if let vc = self.base.presentedViewController {

                return vc.ys.topViewController

            } else if self.base.isKind(of: UINavigationController.self) {

                if let vc = (self.base as! UINavigationController).visibleViewController {
                    return vc.ys.topViewController
                } else {
                    print("nav> \(self)")
                }

            } else if self.base.isKind(of: UITabBarController.self) {

                if let vc = (self.base as! UITabBarController).selectedViewController {
                    return vc.ys.topViewController
                } else {
                    print("tab> \(self)")
                }

            }
            return self.base
        }
    }
}
