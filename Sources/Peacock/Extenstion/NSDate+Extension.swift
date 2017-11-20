/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/
import YsSwift

import UIKit
public extension YSSwift where Base: NSDate {
     public func weak(len: String = "en") -> String {
        let enWeak = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let zhWeak = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
        let calendar = NSCalendar.current
        let weakIndex = calendar.component(Calendar.Component.weekday, from: self.base as Date)-1
        if len == "zh_hans" {
            return zhWeak[weakIndex]
        }else {
            return enWeak[weakIndex]
        }
    }
}
