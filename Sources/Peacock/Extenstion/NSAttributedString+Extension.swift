/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import Foundation
import UIKit
import YsSwift


extension YSSwift where Base: NSMutableAttributedString {

    func colorOfString(_ string: String, color: UIColor) {
        if let range = self.base.string.range(of: string) {
            let start = self.base.string.characters.distance(from: self.base.string.startIndex, to: range.lowerBound)
            // let length = range.upperBound - range.lowerBound // string.characters.startIndex.distanceTo(from: range.lowerBound, to: range.upperBound)
            let end = self.base.string.characters.distance(from: self.base.string.startIndex, to: range.upperBound)
            let length = end - start
            // let length = <#T##String.CharacterView corresponding to your index##String.CharacterView#>.distance(from: range.lowerBound, to: range.upperBound)
            let attrs = [NSAttributedStringKey.foregroundColor: color]
            self.base.setAttributes(attrs, range: NSRange(location: start, length: length))

        }
    }
}
