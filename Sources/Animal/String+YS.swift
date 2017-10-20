/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  String 相关的扩展功能
 ** Copyright © 2017年 尧尚信息科技(www.yourshares.cn). All rights reserved
 ******************************************************************************/
import Foundation

public class YSStringCompatible {
    public let base: String
    public init(_ base: String) {
        self.base = base
    }
}

public extension String {
    public var ys: YSStringCompatible {
        return YSStringCompatible(self)
    }
}

extension YSStringCompatible {
    public func trim() -> String {
        return self.base.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    public func double() -> Double {
        let charset = CharacterSet(charactersIn: ",+%")
        let string = self.base.trimmingCharacters(in: charset).replacingOccurrences(of: ",", with: "")
        
        guard let double = Double(string) else {
            return 0
        }
        return double
    }
    
    public func matches(_ regex: String!) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = self.base as NSString
            let results = regex.matches(in: self.base,
                                        options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range) }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}




