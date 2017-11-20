/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/


import Foundation
import UIKit

@objc public enum YSFont: Int {

    /// (47) 重要数据
    case t01
    /// (31) 重要数据
    case t02
    /// (20) 导航栏和其他标题
    case t03
    /// (18) 次要标题和重要文字
    case t04
    /// (15) 一般正文
    case t05
    /// (13) 提示和辅助信息
    case t06
    /// (10) 提示和辅助信息
    case t07
    /// (16)
    case t08

    case none

    static var fontCache: [Int: UIFont] = [NSInteger: UIFont]()

    var fontSize: CGFloat {
        get {
            var size: CGFloat = 0

            switch self {
            case .t01:
                size = 47
            case .t02:
                size = 31
            case .t03:
                size = 20
            case .t04:
                size = 17
            case .t05:
                size = 15
            case .t06:
                size = 12
            case .t07:
                size = 10
            case .t08:
                size = 16
            default:
                size = 15
            }

            return size
        }
    }

    public var font: UIFont {

        return self.mono
    }

    var boldFont: UIFont {

        let key = 20 + self.rawValue

        if let cacheFont = YSFont.fontCache[key] {
            return cacheFont
        }

        let font = UIFont.boldSystemFont(ofSize: self.fontSize)
        YSFont.fontCache[key] = font

        return font
    }

    var mono: UIFont {

        let key = 30 + self.rawValue

        if let cacheFont = YSFont.fontCache[key] {
            return cacheFont
        }

        guard let font = UIFont(name: "SimHei", size: self.fontSize) else {
            return UIFont.systemFont(ofSize: self.fontSize)
        }

        YSFont.fontCache[key] = font

        return font
    }

    var boldMono: UIFont {

        let key = 40 + self.rawValue

        if let cacheFont = YSFont.fontCache[key] {
            return cacheFont
        }

        //        guard let font = UIFont(name: "HelveticaNeue-Bold", size: self.fontSize) else {
        //            return self.font
        //        }
        guard let font = UIFont(name: "Helvetica-Bold", size: self.fontSize) else {
            return self.font
        }
        YSFont.fontCache[key] = font

        return font
    }

    var lightMono: UIFont {

        let key = 50 + self.rawValue

        if let cacheFont = YSFont.fontCache[key] {
            return cacheFont
        }

        guard let font = UIFont(name: "HelveticaNeue-Light", size: self.fontSize) else {
            return self.font
        }
        //        guard let font = UIFont(name: "Helvetica-Light", size: self.fontSize) else {
        //            return self.font
        //        }
        YSFont.fontCache[key] = font

        return font
    }
}

@objc class YSFontWrapper: NSObject {

    @objc func getFontSize(_ font: YSFont) -> CGFloat {
        return font.fontSize
    }

    @objc func getFont(_ font: YSFont) -> UIFont {
        return font.font
    }
}
