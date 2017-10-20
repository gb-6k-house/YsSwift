//
//  UIButton+Target.swift
//  YsSwift
//
//  Created by niupark on 2017/10/20.
//  Copyright © 2017年 尧尚信息科技. All rights reserved.
//

#if !COCOAPODS
    import YsSwift
#endif

import UIKit
/// Alias for `UIButton`
public typealias Button = UIButton

#if os(macOS) || os(iOS) || os(tvOS)
    
    extension Button: Target {
        public func handle(response: Result<Image>, isFromMemoryCache: Bool) {
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

