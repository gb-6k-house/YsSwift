/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  图片缓存对象
 ** Copyright © 2017年 尧尚信息科技(www.yourshares.cn). All rights reserved
 ******************************************************************************/
import Foundation
import UIKit
#if YSSWIFT_DEBUG
    import YsSwift
#endif

//内存缓存
public final class ImageCache {
    public class CachedImage: CachedItem {
        public var value: AnyObject
        public var memCost: Int {
            guard let image = self.value as? Image else{
                fatalError("value prop must be Image type")
            }
            return image.ys.memSize
        }
        
        public init(value: Image){
            self.value = value
        }

    }
    public static let shared: Cache<CachedImage> = Cache()

}


extension Request {
    //请求的key值
    public var cacheKey: AnyHashable {
        return  AnyHashable(Request.makeCacheKey(self))
    }
    //生成请求的key。 这里相同的请求key相同
    private static func makeCacheKey(_ request: Request) -> Key {
        return Key(request: request) {
            $0.container.urlString == $1.container.urlString
        }
    }
}


public extension  Cache where T: ImageCache.CachedImage {
    /// Accesses the image associated with the given request.
    public subscript(request: Request) -> T? {
        get { return self[request.cacheKey]}
        set { self[request.cacheKey] = newValue}
    }
}
