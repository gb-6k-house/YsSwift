/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import Foundation
//处理网络请求
//如果相同的url请求，在之前的请求回来之前，重复请求不在请求网络，等待之前的网络请求返回作为本次网络请求
//LoaderDeduplicator 所有方法是线程安全的

public final  class LoaderDeduplicator: DataLoading{
    
//    typealias T = E
    private let loader: DataLoading
    private var tasks = [AnyHashable: Task]()
    private let queue = DispatchQueue(label: "com.github.YKit.Animal.LoaderDeduplicator")

    public init(loader: DataLoading) {
        self.loader = loader
    }
    
    public func loadData(with request: Request, token: CancellationToken?, completion: @escaping (Result<(Data, URLResponse)>) -> Void){
        queue.async {
            self._loadData(with: request, token: token, completion: completion)
        }
    }
    
    private func _loadData(with request: Request, token: CancellationToken?, completion: @escaping (Result<(Data, URLResponse)>) -> Void){
        let key = request.loadKey
        let task = tasks[key] ?? startTask(with: request, key: key)
        
        task.retainCount += 1
        task.handlers.append(completion)
        
        token?.register { [weak self, weak task] in
            guard let task = task else { return }
            self?.queue.async { self?.cancel(task, key: key) }
        }
    }
    
    private func startTask(with request: Request, key: AnyHashable) -> Task {
        let task = Task()
        tasks[key] = task
        loader.loadData(with: request, token: task.cts.token) { [weak self, weak task] result in
            guard let task = task else { return }
            self?.queue.async { self?.complete(task, key: key, result: result) }
        }
        return task
    }

    
    private func complete(_ task: Task, key: AnyHashable, result: Result<(Data, URLResponse)>) {
        guard tasks[key] === task else { return } // check if still registered
        task.handlers.forEach { $0(result) }
        tasks[key] = nil
    }
    
    private func cancel(_ task: Task, key: AnyHashable) {
        guard tasks[key] === task else { return } // check if still registered
        task.retainCount -= 1
        if task.retainCount == 0 {
            task.cts.cancel() // cancel underlying request
            tasks[key] = nil
        }
    }
    private final class Task {
        let cts = CancellationTokenSource(lock: Lock())
        var handlers = [DataLoading.DataHandler]()
        var retainCount = 0 // number of non-cancelled handlers
    }

}


public extension Request {
    
    //请求的key值
    public var loadKey: AnyHashable {
        return  AnyHashable(Request.makeLoadKey(self))
    }
    //生成请求的key。 这里相同的请求key相同
    private static func makeLoadKey(_ request: Request) -> Key {
        func isEqual(_ a: URLRequest, _ b: URLRequest) -> Bool {
            return a.cachePolicy == b.cachePolicy && a.allowsCellularAccess == b.allowsCellularAccess
        }
        return Key(request: request) {
            $0.container.urlString == $1.container.urlString
                && isEqual($0.urlRequest, $1.urlRequest)
        }
    }

}



