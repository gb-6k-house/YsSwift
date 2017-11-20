/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(www.yourshares.cn). All rights reserved
 ******************************************************************************/


//定义ys 命名空间
public class YSSwift<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}


/// A type that has yourshares extensions.
public protocol YSCompatible {
    /// Extended type
    associatedtype CompatibleType
    
    /// YSSwift extensions.
    static var ys: YSSwift<CompatibleType>.Type { get set }
    
    /// YSSwift extensions.
    var ys: YSSwift<CompatibleType> { get set }
}

extension YSCompatible {
    /// YSSwift extensions.
    public static var ys: YSSwift<Self>.Type {
        get {
            return YSSwift<Self>.self
        }
        set {
            // this enables using YSSwift to "mutate" base type
        }
    }
    
    /// YSSwift extensions.
    public var ys: YSSwift<Self> {
        get {
            return YSSwift(self)
        }
        set {
            // this enables using YSSwift to "mutate" base object
        }
    }
}

import class Foundation.NSObject



/// Extend NSObject with `ys` proxy.
extension NSObject: YSCompatible { }



