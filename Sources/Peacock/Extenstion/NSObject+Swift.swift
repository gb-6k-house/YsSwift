/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import Foundation
import RxSwift
import YsSwift



public let YSLanguageNotifcation = Notification.Name(rawValue: "YSSwift.Language")
public let YSThemeNotifcation = Notification.Name(rawValue: "YSSwift.theme")

public extension YSSwift where Base: NSObject {


    @discardableResult
    func customize(_ handler: ((Base) -> Void)) -> Base {
        handler(self.base)

        return self.base
    }
    
    @discardableResult
    func handleI18n(_ handler: @escaping () -> Void ) -> YSSwift {
        self.base.i18nHandler = handler
        
        return self
    }
    
    @discardableResult
    func handleTheme(_ handler: @escaping () -> Void ) -> YSSwift {
        self.base.themeHandler = handler
        
        return self
    }

    
    static func className() -> String {
        return "\(self)"
    }
    
    func className() -> String {
        return type(of: self).className()
    }


}

public extension NSObjectProtocol {
    public static func className() -> String {
        return "\(self)"
    }
    func className() -> String {
        return type(of: self).className()
    }
}

open class YSClosureWrapper: NSObject {
    var closure: (() -> Void)?

    init(_ closure: (() -> Void)?) {
        self.closure = closure
    }
}

extension NSObject {
    typealias YSI18nUpdateClosure = () -> Void
    typealias YSThemeUpdateClosure = () -> Void

    
    private struct YSAssociatedKeys {
        static var i18nClosure = "i18nClosure"
        static var themeClosure = "themeClosure"

    }
    
    var themeHandler: YSThemeUpdateClosure? {
        get {
            if let object = objc_getAssociatedObject(self, &YSAssociatedKeys.themeClosure) as? YSClosureWrapper {
                return object.closure
            }
            return nil
        }
        set {
            let object = YSClosureWrapper(newValue)
            objc_setAssociatedObject(self, &YSAssociatedKeys.themeClosure, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if newValue != nil {
                _ = NotificationCenter.default
                    .rx.notification(YSThemeNotifcation)
                    .takeUntil(object.rx.deallocated)
                    .subscribe(
                        onNext: { [weak self] (notif) in
                            guard let `self` = self else {
                                return
                            }
                            self.themeHandler?()
                        }
                )
            }
            
            newValue?()
        }
    }
    


    fileprivate var i18nHandler: YSI18nUpdateClosure? {
        get {
            if let object = objc_getAssociatedObject(self, &YSAssociatedKeys.i18nClosure) as? YSClosureWrapper {
                return object.closure
            }
            return nil
        }
        set {
            let object = YSClosureWrapper(newValue)
            objc_setAssociatedObject(self, &YSAssociatedKeys.i18nClosure, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if newValue != nil {
                _ = NotificationCenter.default
                    .rx.notification(YSLanguageNotifcation)
                    .takeUntil(object.rx.deallocated)
                    .takeUntil(self.rx.deallocated)
                    .subscribe(
                        onNext: { [weak self] (notif) in
                            guard let `self` = self else {
                                return
                            }
                            self.i18nHandler?()
                        }
                )
            }
            
            newValue?()
        }
    }

}
