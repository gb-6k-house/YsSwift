/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/


import UIKit

public let YSPopupWindow = YSWindow(level: 1.0)
public let YSBubbleWindow = YSWindow(level: 2.0)
public let YSPickerWindow = YSWindow(level: 3.0)
public let YSSheetWindow = YSWindow(level: 4.0)
public let YSAlertWindow = YSWindow(level: 5.0)

open class YSWindow: UIWindow {

    let statusBarRelativeController = YSRootViewController()

    var statusBarHidden = false {
        didSet {
            self.statusBarRelativeController.statusBarHidden = statusBarHidden
        }
    }
    var statusBarStyle = UIStatusBarStyle.lightContent {
        didSet {
            self.statusBarRelativeController.statusBarStyle = statusBarStyle
        }
    }
    var statusBarAnimation = UIStatusBarAnimation.fade {
        didSet {
            self.statusBarRelativeController.statusBarAnimation = statusBarAnimation
        }
    }

    public init(level: UIWindowLevel = 0) {
        super.init(frame: UIScreen.main.bounds)

        self.windowLevel = UIWindowLevelStatusBar + level

        self.rootViewController = self.statusBarRelativeController
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

class YSRootViewController: UIViewController {

    var statusBarHidden = false
    var statusBarStyle = UIStatusBarStyle.lightContent
    var statusBarAnimation = UIStatusBarAnimation.fade

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle
    }

    override var prefersStatusBarHidden: Bool {
        return self.statusBarHidden
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.statusBarAnimation
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
}
