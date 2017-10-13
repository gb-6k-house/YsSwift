//
//  UIImageView+Target.swift
//  Pods
//
//  Created by niupark on 2017/10/7.
//
//

import Foundation

#if !COCOAPODS
    import YSKit
#endif


#if os(macOS)
    import Cocoa
    /// Alias for `NSImageView`
    public typealias ImageView = NSImageView
#elseif os(iOS) || os(tvOS)
    import UIKit
    /// Alias for `UIImageView`
    public typealias ImageView = UIImageView
#endif

#if os(macOS) || os(iOS) || os(tvOS)
    /// Default implementation of `Target` protocol for `ImageView`.
    extension ImageView: Target {
        /// Displays an image on success. Runs `opacity` transition if
        /// the response was not from the memory cache.
        public func handle(response: Result<Image>, isFromMemoryCache: Bool) {
            guard let image = response.value else { return }
            self.image = image
            if !isFromMemoryCache {
                let animation = CABasicAnimation(keyPath: "opacity")
                animation.duration = 0.25
                animation.fromValue = 0
                animation.toValue = 1
                let layer: CALayer? = self.layer // Make compiler happy on macOS
                layer?.add(animation, forKey: "imageTransition")
            }
        }
    }
    
#endif
