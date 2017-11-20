/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  UIButton提供网络图片加载能力
 ** Copyright © 2017年 尧尚信息科技(www.yourshares.cn). All rights reserved
 ******************************************************************************/

import YsSwift
import Result

import UIKit
/// Alias for `UIButton`
public typealias Button = UIButton

#if os(macOS) || os(iOS) || os(tvOS)
    
    extension Button: Target {
        public func handle(response: Result<Image, YsSwift.RequestError>, isFromMemoryCache: Bool) {
            guard let image = response.value else { return }
            self.setImage(image, for: .normal)
        }
    }
    
#endif

extension YSSwift where Base: Button {
    
    
    public func loadImage(with url: URL,for state: UIControlState, placeholder placeholderImage: UIImage? = nil) {
        //set placehold image
        if let image = placeholderImage {
            self.base.setImage(image, for: .normal)
        }
        //load image
        Rabbit.loadImage(with: url, into: self.base)
    }
    
    
}

