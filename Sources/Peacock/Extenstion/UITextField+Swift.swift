//
//  UITextField+Swift.swift
//  YSKit
//
//  Created by niupark on 2017/9/8.
//  Copyright © 2017年 尧尚信息科技. All rights reserved.
//

import Foundation
import YsSwift

extension YSSwift where Base: UITextField {
    
    public func changePlaceholderColor(_ color : UIColor) {
        let attrPlaceholder = NSMutableAttributedString.init(string: self.base.placeholder!)
        let dict = NSMutableDictionary.init()
        dict[NSForegroundColorAttributeName] = color;
        attrPlaceholder.addAttributes(dict as! [String : Any], range: NSMakeRange(0, (self.base.placeholder?.characters.count)!))
        self.base.attributedPlaceholder = attrPlaceholder;
    }
}
