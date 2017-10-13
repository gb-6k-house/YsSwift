// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import Foundation
import UIKit

#if !COCOAPODS
    import YSKit
#endif


public final class ImageCache {
    public struct CachedImage: CachedItem {
        public var value: AnyObject
        public var memCost: Int {
            guard let image = self.value as? UIImage else{
                fatalError("value prop must be UIImage type")
            }
            return image.ys.memSize
        }
        public var key: AnyHashable
    }
    public static let shared: Cache<CachedImage> = Cache()

}
