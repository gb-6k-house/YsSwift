/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/
import Foundation
import UIKit

public enum YSLanguage:Int, YSEnumable {
    
    case simplifiedChinese = 0
    case traditionalChinese = 1
    case english = 2
    case german = 3
    case french = 4
    case japanese = 5

    case `default` = -1
    
    public var i18n: String {
        switch self {
        case .simplifiedChinese:
            return "setting.config.language.zh_hans"
        case .traditionalChinese:
            return "setting.config.language.zh_hant"
        case .english:
            return "setting.config.language.en"
        case .german:
            return "setting.config.language.german"
        case .french:
            return "setting.config.language.french"
        case .japanese:
            return "setting.config.language.japanese"
        case .default:
            if YSAppManager.isChinese {
                return "setting.config.language.zh_hans"
            } else {
                return "setting.config.language.en"
            }
        }
    }
    
   public var icon: UIImage? {
        return nil
    }
    
   public var value: AnyObject {
        switch self {
        case .simplifiedChinese:
            return "zh" as AnyObject
        case .traditionalChinese:
            return "zh-hant" as AnyObject
        case .english:
            return "en" as AnyObject
        case .german:
            return "de" as AnyObject
        case .french:
            return "fr" as AnyObject
        case .japanese:
            return "ja" as AnyObject
        default:
            return "zh" as AnyObject
        }
    }
  public  static var key: String {
        return "language"
    }
    
    
    /// 第一次启动，根据本地语言设置app的语言，（需要改进为可扩展）
   public static var defaultValue: YSLanguage {
        
        // 先根据当前语言来判断
        let language = Locale.preferredLanguages[0]
        if language.hasPrefix("en") {
            return .english
        } else if language.hasPrefix("de") {
            return .german
        } else if language.hasPrefix("fr") {
            return .french
        } else if language.hasPrefix("zh-Hant") || language.hasPrefix("zh-HK") || language.hasPrefix("zh-TW") {
            return .traditionalChinese                       // 先判断繁体，不然都会变成简体
        } else if language.hasPrefix("zh") {
            return .simplifiedChinese
        } else if language.hasPrefix("ja") {
            return .japanese
        }
        
        // 再根据当前地区来判断
        guard let code = Locale.current.regionCode else {
            return .english
        }
        
        if [
            "FR", //法国
            "MC", //摩纳哥
            "CD", //刚果（金）
            "CG", //刚果（布）
            "CI", //科特迪瓦
            "HT", //海地
            "DZ", //阿尔及利亚
            "TN", //突尼斯
            ].contains(code) {
            return .french
        } else if [
            "DE", //德国
            ].contains(code) {
            return .german
        } else if [
            "JP", //德国
            ].contains(code) {
            return .japanese
        }
        
        return .english
    }
    

   public static var title: String = "setting.config.language"
    
   public static var allValues: [YSLanguage] = [
        english,
        simplifiedChinese,
        traditionalChinese,
        ]
    
    static func value(_ value: String) -> YSLanguage? {
        for v in allValues {
            if v.value as! String == value {
                return v
            }
        }
        return nil
    }

}


let LANG = YSLanguageManager()

public func I18n(_ key: String?) -> String {
    if let key = key, !key.isEmpty {
        return LANG.i18n(key)
    }
    return ""
}



public func I18n(_ format: String?, _ arguments: CVarArg...) -> String {
    if let format = format, !format.isEmpty {
        return LANG.i18n(format, arguments: arguments)
    }
    return ""
}

var changedLanguage = YSLanguage.default

public func changeLanguage(_ lan: YSLanguage) {
    changedLanguage = lan
}

class YSLanguageManager: NSObject {
    static var CurrentLanguage = YSLanguage.simplifiedChinese
    static var LocalizedStringDictionary = NSDictionary()
    static var DefaultLocalizedStringDictionary = NSDictionary()
    
    var languageKey: String {
        switch YSLanguageManager.CurrentLanguage {
        case .simplifiedChinese:
            return "zh-Hans"
        case .english:
            return "en"
        case .traditionalChinese:
            return "zh-Hant"
        default:
            return "zh-Hans"
        }
    }

    fileprivate override init() {
        super.init()
    }

    func i18n(_ key: String, reportError: Bool = true) -> String {
        if YSLanguageManager.CurrentLanguage != changedLanguage ||
            YSLanguageManager.LocalizedStringDictionary.count == 0 {
            YSLanguageManager.CurrentLanguage = changedLanguage
            if let path = Bundle.main.path(forResource: self.languageKey, ofType: "lproj") {

                if let currentLanguageBundle = Bundle(path: path) {

                    if let localizedStringsFilePath = currentLanguageBundle.path(forResource: "Localizable", ofType: "strings") {

                        YSLanguageManager.LocalizedStringDictionary = NSDictionary(contentsOfFile: localizedStringsFilePath)!
                    }
                }
            }
        }

        if let value = YSLanguageManager.LocalizedStringDictionary[key] as? String, !value.isEmpty {
            return value
        }
        
       
        /// 如果当前语言没有则取简体版本
        if YSLanguageManager.DefaultLocalizedStringDictionary.count == 0 {
            if let path = Bundle.main.path(forResource: "zh-Han", ofType: "lproj") {
                
                if let currentLanguageBundle = Bundle(path: path) {
                    
                    if let localizedStringsFilePath = currentLanguageBundle.path(forResource: "Localizable", ofType: "strings") {
                        
                        YSLanguageManager.DefaultLocalizedStringDictionary = NSDictionary(contentsOfFile: localizedStringsFilePath)!
                    }
                }
            }
        }
        
        if let value = YSLanguageManager.DefaultLocalizedStringDictionary[key] as? String, !value.isEmpty {
            return value
        }

        return key
    }

    func i18n(_ format: String, arguments: [CVarArg]) -> String {
        return String(format: self.i18n(format), arguments: arguments)
    }
}

extension String {
    var i18n: String {
        return LANG.i18n(self)
    }

    func i18n(_ arguments: CVarArg...) -> String {
        return LANG.i18n(self, arguments: arguments)
    }
}
