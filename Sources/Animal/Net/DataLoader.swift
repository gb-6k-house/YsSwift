/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  资源加载器，加载网络资源
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import Foundation


public protocol DataLoading {
    /// Loads data with the given request.
    func loadData(with request: Request, token: CancellationToken?, completion: @escaping (Result<(Data, URLResponse)>) -> Void)
}

public final class Loader: DataLoading {
    public let session: URLSession
    private let scheduler: AsyncScheduler

    public init(configuration: URLSessionConfiguration = Loader.defaultConfiguration,
                scheduler: AsyncScheduler = Loader.defaultScheduler) {
        self.session = URLSession(configuration: configuration)
        self.scheduler = scheduler
    }

    /// Returns a default configuration which has a `sharedUrlCache` set
    /// as a `urlCache`.
    public static var defaultConfiguration: URLSessionConfiguration {
        let conf = URLSessionConfiguration.default
        conf.urlCache = Loader.sharedUrlCache
        return conf
    }
    
    /// Shared url cached used by a default `DataLoader`.
    public static let sharedUrlCache = URLCache(
        memoryCapacity: 0,
        diskCapacity: 150 * 1024 * 1024, // 150 MB
        diskPath: "com.github.YKit.Animal.Cache"
    )
    
    public static var defaultScheduler: AsyncScheduler {
        return RateLimiter(scheduler: OperationQueueScheduler(maxConcurrentOperationCount: 6))
    }
    
    /// Loads data with the given request.
    public func loadData(with request: Request, token: CancellationToken?, completion: @escaping (Result<(Data, URLResponse)>) -> Void) {
        scheduler.execute(token: token) { finish in
            let task = self.session.dataTask(with: request.urlRequest) { data, response, error in
                if let data = data, let response = response, error == nil {
                    completion(.success((data, response)))
                } else {
                    completion(.failure((error ?? NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil))))
                }
                finish()
            }
            token?.register {
                task.cancel()
                finish()
            }
            task.resume()
        }
    }
}
