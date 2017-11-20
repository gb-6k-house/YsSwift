/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import FCUUID
import CoreTelephony

open class YSUtils: NSObject {

    static var screenSize = UIScreen.main.bounds

    static func snapshotForView(_ inputView: UIView) -> UIView {

        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let cellImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let imageView = UIImageView(image: cellImage)
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = 0.0
        imageView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        imageView.layer.shadowRadius = 4.0
        imageView.layer.shadowOpacity = 1.0
        return imageView
    }

    // 获取存储的DeviceID
    static func getDeviceUUID() -> String {
        return FCUUID.uuidForDevice()
    }

 
    static func getCurrentLocale() -> String {
        return ((Locale.current as NSLocale).object(forKey: NSLocale.Key.identifier) as? String) ?? "en_US"
    }

    static func getCurrentyCurrencyCode() -> String {
        return ((Locale.current as NSLocale).object(forKey: NSLocale.Key.currencyCode) as? String) ?? "CNY"
    }

    static func getSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }


    static func getTimeZone() -> String {
        return TimeZone.autoupdatingCurrent.identifier
    }

    static func getAppVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    static func nowTimeIntervalSince1970() -> TimeInterval {
        return Date().timeIntervalSince1970
    }

    static func calculateTextSize(_ string: String, font: UIFont) -> CGSize {
        let nsstring = string as NSString
        let rect = nsstring.boundingRect(with: CGSize(width: 10000, height: 100), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return CGSize(width: ceil(rect.size.width), height: ceil(rect.size.height))
    }

    static func getMNCAndMCC() -> (String, String) {
        let networkInfo = CTTelephonyNetworkInfo()
        let carrieInfo = networkInfo.subscriberCellularProvider
        let MNC = carrieInfo?.mobileNetworkCode ?? "-1"
        let MCC = carrieInfo?.mobileCountryCode ?? "-1"
        return (MNC, MCC)
    }

    @discardableResult
    static func timeCalculate(_ name: String? = nil, _ block: () -> Void) -> TimeInterval {
        let pre = Date()
        block()
        let post = Date()
        let timeInterval = post.timeIntervalSince(pre) * 1000
        return timeInterval
    }

}
