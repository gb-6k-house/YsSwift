/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import UIKit



@objc public enum YSColor: Int {
    
    case line
    case c101   //背景色
    case c102   //
    case c103   //placehold字体颜色
    case c104

    case c201   //蓝色
    
    case c301   //
    
    case c401
    
    case c501
    
    case none
    //白色主题
    fileprivate static let lightTheme: [Int: UIColor] = {

        var theme = [Int: UIColor]()
        
        theme[YSColor.line.rawValue] = UIColor(0xA4A4A4FF)
        
        theme[YSColor.c101.rawValue] = UIColor(0xFAFAFAFF)
        theme[YSColor.c102.rawValue] = UIColor(0x9D9D9DFF)
        theme[YSColor.c103.rawValue] = UIColor(0x8C8C8CFF)
        theme[YSColor.c104.rawValue] = UIColor(0xF2F2F2FF)


        
        theme[YSColor.c201.rawValue] = UIColor(0x00051FFF)
        
        theme[YSColor.c301.rawValue] = UIColor(0x0071FDFF)

        
        theme[YSColor.c401.rawValue] = UIColor(0xECECECFF)

        
        theme[YSColor.c501.rawValue] = UIColor(0x898f98FF)


        theme[YSColor.none.rawValue] = UIColor(0xFFFFFF00)
        return theme
    }()

    fileprivate static let darkTheme: [Int: UIColor] = {

        var theme = [Int: UIColor]()

        return theme
    }()

    fileprivate static var currentTheme = YSColor.lightTheme

    public var dark: UIColor {
        get {
            return YSColor.getColor(self, theme: YSColor.darkTheme)
        }
    }

    public var light: UIColor {
        get {
            return YSColor.getColor(self, theme: YSColor.lightTheme)
        }
    }

    public var color: UIColor {
        get {
            return YSColor.getColor(self, theme: YSColor.currentTheme)
        }
    }
   
    public static func getColor(_ color: YSColor, theme: [Int: UIColor]) -> UIColor {

        switch color {
        default:
            return theme[color.rawValue]!
            
        }
    }
}
