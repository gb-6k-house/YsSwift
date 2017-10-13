/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import Foundation


public class YSDataCompatible {
    public let base: Data
    public init(_ base: Data) {
        self.base = base
    }
}

public extension Data {
    public var ys: YSDataCompatible {
        return YSDataCompatible(self)
    }
}

extension YSDataCompatible {
    public func utf8String() -> String {
        if let str = NSString(data: self.base, encoding: String.Encoding.utf8.rawValue) {
            return str as String
        }
        return ""
    }
}
