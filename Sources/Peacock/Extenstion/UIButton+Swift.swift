/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import Foundation
import UIKit
#if YSSWIFT_DEBUG
    import YsSwift
#endif



/*
 枚举 设置 图片的位置
 */
public enum YSButtonImagePosition : Int{
    
    case top = 0
    case left
    case bottom
    case right
}

public extension YSSwift where Base: UIButton {
    /**
     imageName:图片的名字
     title：button 的名字
     type ：image 的位置
     Space ：图片文字之间的间距
     */
    func setImageAndTitle(imageName: String,title: String,type: YSButtonImagePosition, space:CGFloat)  {
        
        self.base.setTitle(title, for: .normal)
        self.base.setImage(UIImage(named:imageName), for: .normal)
        
        let imageWith: CGFloat = (self.base.imageView?.frame.size.width)!
        let imageHeight: CGFloat = (self.base.imageView?.frame.size.height)!
        
        var labelWidth: CGFloat = 0.0;
        var labelHeight: CGFloat = 0.0;
        
        labelWidth = CGFloat(self.base.titleLabel!.intrinsicContentSize.width)
        labelHeight = CGFloat(self.base.titleLabel!.intrinsicContentSize.height)
        
        var  imageEdgeInsets: UIEdgeInsets = UIEdgeInsets()
        var  labelEdgeInsets: UIEdgeInsets = UIEdgeInsets()
        
        switch type {
        case .top:
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight - space/2.0, 0, 0, -labelWidth)
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0)
            break;
        case .left:
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0)
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0)
            break;
        case .bottom:
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth)
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0)
            break;
        case .right:
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0)
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0)
            break;
        }
        
        // 4. 赋值
        self.base.titleEdgeInsets = labelEdgeInsets
        self.base.imageEdgeInsets = imageEdgeInsets
    }
}
