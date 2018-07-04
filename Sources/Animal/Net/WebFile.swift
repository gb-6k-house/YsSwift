/******************************************************************************
 ** auth: liukai
 ** date: 2018/10
 ** ver : 1.0
 ** desc:  网络文件
 ** Copyright © 2017年 尧尚信息科技(www.yourshares.cn). All rights reserved
 ******************************************************************************/

import Foundation
import Result

public final class WebFile: NSObject, URLSessionDelegate {
    public typealias CompletionHandler = (URL) -> Void
    public typealias ProgressHandler = (CGFloat) -> Void

    private var session: URLSession {
        return URLSession(configuration: WebFile.defaultConfiguration, delegate: self, delegateQueue: nil)
    }
    private let scheduler: AsyncScheduler
    private let cancelToken = CancellationTokenSource().token
    public let  request: Request
    private var comletionHandler: CompletionHandler?
    private var progressHandler: ProgressHandler?
    public init(with request: Request){
        self.scheduler = WebFile.defaultScheduler
        self.request = request
    }
    
    
    public static var defaultConfiguration: URLSessionConfiguration {
        let conf = URLSessionConfiguration.default
        return conf
    }
    //缺省的调度线程，根据令牌桶算法进行了流量控制，缺省频率是45/s
    public static var defaultScheduler: AsyncScheduler {
        return RateLimiter(scheduler: OperationQueueScheduler(maxConcurrentOperationCount: 6))
    }
    //URLSessionDownloadDelegate
    private func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //获取进度
        let written:CGFloat = (CGFloat)(totalBytesWritten)
        let total:CGFloat = (CGFloat)(totalBytesExpectedToWrite)
        self.progressHandler?( written/total)
    }
    private func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        self.comletionHandler?(location)
    }

    

    /// Loads data with the given request.
    public func download(completion: @escaping  WebFile.CompletionHandler, progress: WebFile.ProgressHandler?) {
        self.comletionHandler = completion
        self.progressHandler = progress
        scheduler.execute(token: self.cancelToken) { finish in
            let task = self.session.downloadTask(with: self.request.urlRequest) { url, response, error in
                finish()
            }
            self.cancelToken.register {
                task.cancel()
                finish()
            }
            task.resume()
        }
    }
}


