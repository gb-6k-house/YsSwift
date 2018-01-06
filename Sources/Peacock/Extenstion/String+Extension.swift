/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import libPhoneNumber_iOS
import YsSwift



extension YSStringCompatible {

    static let nilValue: String = "-"


    public func intValue() -> Int {
        let charset = CharacterSet(charactersIn: ",+%")
        let string = self.base.trimmingCharacters(in: charset).replacingOccurrences(of: ",", with: "")

        guard let myint = Int(string) else {
            return 0
        }
        return myint
    }

    public func isPhone(_ isoCode: String) -> Bool {
        let phoneUtil = NBPhoneNumberUtil()
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(self.base, defaultRegion: isoCode)
            let type = NBPhoneNumberUtil.sharedInstance().getNumberType(phoneNumber)
            return type == .MOBILE || type == .FIXED_LINE_OR_MOBILE || type == .PAGER
        } catch _ as NSError {
            return false
        }
    }



    func toURL() -> URL? {
        var result = URL.init(string: self.base)
        if result == nil {
            if let encodestr = self.base.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                result = URL.init(string: encodestr)
            }
        }
        return result
    }

    public func isEmail() -> Bool {

        let regex = "^[A-Za-z0-9!#$%&'+/=?^_`{|}~-]+(.[A-Za-z0-9!#$%&'+/=?^_`{|}~-]+)*@([A-Za-z0-9]+(?:-[A-Za-z0-9]+)?.)+[A-Za-z0-9]+(-[A-Za-z0-9]+)?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)

        return predicate.evaluate(with: self.base)
    }

    public func isPassword() -> Bool {

        if self.base.characters.count < 6 || self.base.characters.count > 20 {
            return false
        }

        let regex = "\\d+[a-zA-Z]+[\\da-zA-Z]*|[a-zA-Z]+\\d+[\\da-zA-Z]*"
//        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
//
//        let regex2 = "[a-zA-Z]+\\d+[\\da-zA-Z]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)

        return predicate.evaluate(with: self.base)
    }
    
    public func latinString() -> String {
        /// 该方法非常耗cpu，容易造成iphone5甚至6的卡顿，需要放在后台线程中完成，完成后在主线程刷新
        let str = NSMutableString(string: self.base) as CFMutableString
        
        CFStringTransform(str, nil, kCFStringTransformToLatin, false)
        CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false)
        
        return (str as NSString) as String
    }

    
    
    public func toData() -> Data? {
       return self.base.data(using: String.Encoding.utf8)
    }
}
