/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import UIKit

open class YSNavigationController: UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationBar.us.handleTheme { [unowned self] in
//            
//            self.navigationBar.titleTextAttributes = [
//                NSForegroundColorAttributeName: USColor.c301.color,
//                NSFontAttributeName: USFont.t04.font
//            ]
//            self.navigationBar.shadowImage = UIImage.us_image(USColor.c502.color, size: CGSize(width: 0.5, height: 0.5))
//            self.navigationBar.setBackgroundImage(UIImage.us_image(USColor.c103.color, size: CGSize(width: UIScreen.main.bounds.width, height: 64)), for: .default)
//            self.navigationBar.barTintColor = USColor.c301.color
//            self.navigationBar.tintColor = USColor.c301.color
//        }
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open override var prefersStatusBarHidden: Bool {
        return self.topViewController!.prefersStatusBarHidden
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController!.preferredStatusBarStyle
    }
    
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.topViewController!.preferredStatusBarUpdateAnimation
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController!.supportedInterfaceOrientations
    }
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.topViewController!.preferredInterfaceOrientationForPresentation
    }
}
