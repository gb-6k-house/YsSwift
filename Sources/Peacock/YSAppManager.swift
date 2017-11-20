/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import UIKit
import IQKeyboardManagerSwift


open class YSAppManager: NSObject {
        
    fileprivate var dismissTap: UITapGestureRecognizer?
    fileprivate var bgTask = UIBackgroundTaskInvalid
    
    open  var window: UIWindow!
    
    
    open var topViewController: UIViewController {
        return self.tab.ys.topViewController
    }
    
    open func makeTabShow() {
        self.configTab()
        self.window.rootViewController = self.tab
    }
    

    final public func configWindow() -> UIWindow {
        
        self.window = UIWindow()
        self.configDebug()
        self.configAppearence()
        self.configController()
        self.configVariable()
        self.configNotification()
        
        return self.window
    }
    
    open func configDebug() {
        
    }
    
    open func configAppearence() {
        
        
        //        UITabBar.appearance().isTranslucent = false
    }
    
    
    lazy open var tab: UITabBarController = {
        return UITabBarController()
    }()
    
    /// 构建底部tabbar，
    open func configTab() {

    }
    
    open func configController() {
        
        self.window.makeKeyAndVisible()
        
    }
    
    
    open func configVariable() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().overrideKeyboardAppearance = false
        IQKeyboardManager.sharedManager().keyboardAppearance = .default
        IQKeyboardManager.sharedManager().shouldFixInteractivePopGestureRecognizer = false
    }
    
    open func configNotification() {
    }
    
    final  func backgroudKeepActive() {
        let app = UIApplication.shared
        self.bgTask = app.beginBackgroundTask(expirationHandler: { 
            app.endBackgroundTask(self.bgTask)
            self.bgTask = UIBackgroundTaskInvalid
        })
    }
    
}

extension YSAppManager {
    
   open static var isChinese: Bool {
        get {
            let language = Locale.preferredLanguages[0]
            return language.hasPrefix("zh")
        }
    }
    
   open static var isCN: Bool {
        get {
            let countryCode = (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
            
            return countryCode == "CN"
        }
    }
    
   open static var isHK: Bool {
        get {
            let countryCode = (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
            
            return countryCode == "HK"
        }
    }
    
}


