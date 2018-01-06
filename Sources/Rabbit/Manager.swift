/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  管理类
 ** Copyright © 2017年 尧尚信息科技(www.yourshares.cn). All rights reserved
 ******************************************************************************/

import Foundation
#if YSSWIFT_DEBUG
    import YsSwift
#endif

import Result

//网络图片加载管理类
//完成如下流程: 数据从网络中下载 ->数据缓存本地(硬盘+内存) ->  数据解析成图片 -> 返回上层应用
public final class Manager {
    public var loader: Loading
    public let cache: Cache<ImageCache.CachedImage>?
    public let defauleLoader : Loader = {
        return Loader.shared as! Loader
    }()
    /// A set of trusted hosts when receiving server trust challenges.
   //single instance
    public static let shared = Manager(loader: Loader.shared, cache: ImageCache.shared)
    
   //
    public init(loader: Loading, cache: Cache<ImageCache.CachedImage>? = nil) {
        self.loader = loader
        self.cache = cache
    }
    // MARK: Loading Images into Targets
    
    /// Loads an image into the given target. Cancels previous outstanding request
    /// associated with the target.
    ///
    /// If the image is stored in the memory cache, the image is displayed
    /// immediately. The image is loaded using the `loader` object otherwise.
    ///
    /// `Manager` keeps a weak reference to the target. If the target deallocates
    /// the associated request automatically gets cancelled.
    public func loadImage(with request: Request, into target: Target) {
        loadImage(with: request, into: target) { [weak target] in
            target?.handle(response: $0, isFromMemoryCache: $1)
        }
    }
    
    public typealias Handler = (Result<Image, YsSwift.RequestError>, _ isFromMemoryCache: Bool) -> Void
    
    /// Loads an image and calls the given `handler`. The method itself
    /// **doesn't do** anything when the image is loaded - you have full
    /// control over how to display it, etc.
    ///
    /// The handler only gets called if the request is still associated with the
    /// `target` by the time it's completed. The handler gets called immediately
    /// if the image was stored in the memory cache.
    ///
    /// See `loadImage(with:into:)` method for more info.
    public func loadImage(with request: Request, into target: AnyObject, handler: @escaping Handler) {
        assert(Thread.isMainThread)
        
        // Cancel outstanding request if any
        cancelRequest(for: target)
        
        // Quick synchronous memory cache lookup
        if let image = cachedImage(for: request) {
            handler(.success(image), true)
            return
        }
        
        // Create context and associate it with a target
        let cts = CancellationTokenSource(lock: CancellationTokenSource.lock)
        let context = Context(cts)
        Manager.setContext(context, for: target)
        
        // Start the request
        loadImage(with: request, token: cts.token) { [weak context, weak target] in
            guard let context = context, let target = target else { return }
            guard Manager.getContext(for: target) === context else { return }
            handler($0, false)
            context.cts = nil // Avoid redundant cancellations on deinit
        }
    }
    
    // MARK: Loading Images w/o Targets
    
    /// Loads an image with a given request by using manager's cache and loader.
    ///
    /// - parameter completion: Gets called asynchronously on the main thread.
    public func loadImage(with request: Request, token: CancellationToken?, completion: @escaping (Result<Image, YsSwift.RequestError>) -> Void) {
            if token?.isCancelling == true { return } // Fast preflight check
            self._loadImage(with: request, token: token) { result in
                DispatchQueue.main.async { completion(result) }
            }
    }
    
    private func _loadImage(with request: Request, token: CancellationToken? = nil, completion: @escaping (Result<Image, YsSwift.RequestError>) -> Void) {
        // Check if image is in memory cache
        if let image = cachedImage(for: request) {
            completion(.success(image))
        } else {
            // Use underlying loader to load an image and then store it in cache
            loader.loadImage(with: request, token: token) { [weak self] in
                if let image = $0.value {
                    self?.store(image: image, for: request)
                }
                completion($0)
            }
        }
    }

    
    /// Cancels an outstanding request associated with the target.
    public func cancelRequest(for target: AnyObject) {
        assert(Thread.isMainThread)
        if let context = Manager.getContext(for: target) {
            context.cts?.cancel()
            Manager.setContext(nil, for: target)
        }
    }
    
    
    // MARK: Memory Cache Helpers
    
    private func cachedImage(for request: Request) -> Image? {
        return cache?[request]?.value as? Image
    }
    
    private func store(image: Image, for request: Request) {
        cache?[request] = ImageCache.CachedImage(value: image)
    }
    
    // MARK: Managing Context
    
    private static var contextAK = "com.github.YKit.Manager.Context.AssociatedKey"
    
    // Associated objects is a simplest way to bind Context and Target lifetimes
    // The implementation might change in the future.
    private static func getContext(for target: AnyObject) -> Context? {
        return objc_getAssociatedObject(target, &contextAK) as? Context
    }
    
    private static func setContext(_ context: Context?, for target: AnyObject) {
        objc_setAssociatedObject(target, &contextAK, context, .OBJC_ASSOCIATION_RETAIN)
    }
    
    private final class Context {
        var cts: CancellationTokenSource?
        
        init(_ cts: CancellationTokenSource) { self.cts = cts }
        
        // Automatically cancel the request when target deallocates.
        deinit { cts?.cancel() }
    }

}


public extension Manager {
    /// Loads an image into the given target. See the corresponding
    /// `loadImage(with:into)` method that takes `Request` for more info.
    public func loadImage(with url: URL, into target: Target) {
        loadImage(with: Request(url: url), into: target)
    }
    
    /// Loads an image and calls the given `handler`. The method itself
    /// **doesn't do** anything when the image is loaded - you have full
    /// control over how to display it, etc.
    ///
    /// The handler only gets called if the request is still associated with the
    /// `target` by the time it's completed. The handler gets called immediately
    /// if the image was stored in the memory cache.
    ///
    /// See `loadImage(with:into:)` method for more info.
    public func loadImage(with url: URL, into target: AnyObject, handler: @escaping Handler) {
        loadImage(with: Request(url: url), into: target, handler: handler)
    }
}

