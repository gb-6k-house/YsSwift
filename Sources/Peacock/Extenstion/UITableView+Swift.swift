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



extension YSSwift where Base: UITableView {

    public func register<T: UITableViewCell>(_: T.Type) {
        self.base.register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }

    public func registerHeaderFooterView<T: UIView>(_: T.Type) {
        self.base.register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
    }

    public func dequeueCell<T: UITableViewCell>(_ indexPath: IndexPath) -> T {
        return self.base.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    public func dequeueHeaderFooterView<T: UIView>() -> T {
        return self.base.dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as! T
    }
}
