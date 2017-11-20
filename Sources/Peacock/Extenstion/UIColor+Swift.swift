/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/
import UIKit


public extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, alpha: Float? = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        assert(alpha! >= 0.0 && alpha! <= 1.0, "Invalid alpha component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha!))
    }
    
    convenience init(hex: Int, alpha: Float? = 1.0) {
        self.init(red: (hex >> 16) & 0xff, green: (hex >> 8) & 0xff, blue: hex & 0xff, alpha: alpha)
    }
    
    convenience init(_ rgba: UInt32) {
        self.init(
            red: Int(rgba >> 24) & 0xff,
            green: Int(rgba >> 16) & 0xff,
            blue: Int(rgba >> 8) & 0xff,
            alpha: Float(rgba & 0xff) / 255.0
        )
    }
}
