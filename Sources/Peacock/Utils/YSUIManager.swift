/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import UIKit
import Foundation

let UI = YSUIManager()

open class YSUIManager: NSObject {

    fileprivate override init() {
        super.init()
    }

    public var splitWidth = 1.0 / UIScreen.main.scale
    public var screenWidth = UIScreen.main.bounds.size.width
    public var screenHeight = UIScreen.main.bounds.size.height

    public var statusHeight = UIApplication.shared.statusBarFrame.size.height

//    var navBarheight = APP.topViewController.navigationController?.navigationBar.bounds.size.height ?? 0.0

    public var exchangeIconSize = CGSize(width: 20, height: 12)

    public var barFixedSpace: UIBarButtonItem {
        let space: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        space.width = 5.0

        return space
    }

    public func makeBarButtonItems(_ items: [UIBarButtonItem], adjust: CGFloat = 0) -> [UIBarButtonItem] {

        let space = UI.barFixedSpace
        space.width = space.width + adjust
        var array = [space]
        array.append(contentsOf: items)

        return array
    }

    public func makeBarIconButton(view: UIView) -> UIBarButtonItem {

        return UIBarButtonItem(customView: view)
    }

    public func hideKeyboard() {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    

}
