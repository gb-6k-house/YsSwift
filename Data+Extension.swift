/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import Foundation

extension Data {

    public func utf8String() -> String {
        if let str = NSString(data: self, encoding: String.Encoding.utf8.rawValue) {
            return str as String
        }
        return ""
    }

}
