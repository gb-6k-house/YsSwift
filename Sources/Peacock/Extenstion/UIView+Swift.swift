/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import Foundation
import UIKit
#if YSSWIFT_DEBUG
    import YsSwift
#endif

extension YSSwift where Base: UIView {
    public var viewController: UIViewController? {
        get {
            var nextResponder: UIResponder? = self.base

            repeat {
                nextResponder = nextResponder?.next

                if let viewController = nextResponder as? UIViewController {
                    return viewController
                }

            } while nextResponder != nil

            return nil
        }
    }
}
