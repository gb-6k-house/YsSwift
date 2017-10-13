/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  UIImage扩展功能
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/


import UIKit

extension YSSwift where Base: UIView {
    
    /// iOS截图，使用WKWebView截图会有问题
    ///
    /// - Parameter view: 显示图片View
    /// - Returns: 截取图片
    public func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.base.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.base.layer.render(in: context)
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return capturedImage
    }
}


