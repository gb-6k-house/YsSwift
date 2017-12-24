/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import Moya
import RxSwift
import ObjectMapper
import SwiftyJSON
#if YSSWIFT_DEBUG
    import YsSwift
#endif


extension MoyaProvider {

    public func requestJSON(_ token: Target) -> Observable<JSON?> {

        // Creates an observable that starts a request each time it's subscribed to.
        return Observable.create { [weak self] observer in

            let cancellableToken = self?.request(token) { result in
                switch result {
                case let .success(response):
                    DispatchQueue.global().async {
                        do {
                            let data = try self?.validateResponse(response)
                            DispatchQueue.main.async(execute: {
                                observer.onNext(data)
                                observer.onCompleted()
                            })
                        
                        } catch {
                            DispatchQueue.main.async(execute: {
                                observer.onError(error)
                            })
                        }
                    }

                    break
                case let .failure(error):
                    DispatchQueue.main.async(execute: {
                        observer.onError(YSNetWorkError.networkError(error._code, error.response?.description ?? "网络内部错误"))
                    })
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
    
    /// Designated request-making method.
    public func requestObjectMapper<T: Mappable>(_ token: Target, validate: Bool = false) -> Observable<T> {

        // Creates an observable that starts a request each time it's subscribed to.
        return Observable.create { [weak self] observer in
            let cancellableToken = self?.request(token) { result in
                switch result {
                case let .success(response):
                    DispatchQueue.global().async {
                        do {
                            let dataJSON = try self?.validateResponse(response)
                            if let data = dataJSON, let dictionary = data.dictionaryObject,
                                let object =  Mapper<T>().map(JSON: dictionary) {
                                DispatchQueue.main.async(execute: {
                                    observer.onNext(object)
                                    observer.onCompleted()
                                })
                            }else {
                                DispatchQueue.main.async(execute: {
                                    observer.onError(YSNetWorkError.networkError(-2, "数据错误"))
                                })
                            }
                        }catch {
                            DispatchQueue.main.async(execute: {
                                observer.onError(error)
                            })
                        }
                    }

                    break
                case let .failure(error):
                        DispatchQueue.main.async(execute: {
                            observer.onError(YSNetWorkError.networkError(error._code, error.response?.description ?? "网络内部错误"))
                        })

                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }

    public func requestArrayMapper<T: Mappable>(_ token: Target, validate: Bool = false) -> Observable<[T]> {

        // Creates an observable that starts a request each time it's subscribed to.
        return Observable.create { [weak self] observer in
            let cancellableToken = self?.request(token) { result in
                switch result {
                case let .success(response):
                    DispatchQueue.global().async {
                        do {
                            let dataJSON = try self?.validateResponse(response)
                            if let data = dataJSON, let array = data.arrayObject as? [[String: Any]],
                                let objects =  Mapper<T>().mapArray(JSONArray: array) {
                                DispatchQueue.main.async(execute: {
                                    observer.onNext(objects)
                                    observer.onCompleted()
                                })
                                
                            }else {
                                DispatchQueue.main.async(execute: {
                                    observer.onError(YSNetWorkError.networkError(-2, "数据错误"))
                                })
                            }

                        }catch {
                            DispatchQueue.main.async(execute: {
                                observer.onError(error)
                            })
                        }
                    }
                case let .failure(error):
                    DispatchQueue.main.async(execute: {
                        observer.onError(YSNetWorkError.networkError(error._code, error.response?.description ?? "网络内部错误"))
                    })
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }

    /// Designated request-making method.
    public func requestAny<T: Any>(_ token: Target, validate: Bool = false) -> Observable<T> {

        // Creates an observable that starts a request each time it's subscribed to.
        return Observable.create { [weak self] observer in
            let cancellableToken = self?.request(token) { result in
                switch result {
                case let .success(response):
                    
                    DispatchQueue.global().async {
                        do {
                            let dataJSON = try self?.validateResponse(response)
                            if let object: T = dataJSON?.object as? T  {
                                DispatchQueue.main.async(execute: {
                                    observer.onNext(object)
                                    observer.onCompleted()
                                })
                                
                            }else {
                                DispatchQueue.main.async(execute: {
                                    observer.onError(YSNetWorkError.networkError(-2, "数据错误"))
                                })
                            }

                        }catch {
                            DispatchQueue.main.async(execute: {
                                observer.onError(error)
                            })
                        }
                    }

                case let .failure(error):

                    DispatchQueue.main.async(execute: {
                        observer.onError(YSNetWorkError.networkError(error._code, error.response?.description ?? "网络内部错误"))
                    })
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }

    public func requestAnyArray<T: Any>(_ token: Target, validate: Bool = false) -> Observable<[T]> {

        // Creates an observable that starts a request each time it's subscribed to.
        return Observable.create { [weak self] observer in
            let cancellableToken = self?.request(token) { result in
                switch result {
                case let .success(response):

                    
                    DispatchQueue.global().async {
                        do {
                            let dataJSON = try self?.validateResponse(response)
                            if let objects: [T] = dataJSON?.arrayObject as? [T] {
                                DispatchQueue.main.async(execute: {
                                    observer.onNext(objects)
                                    observer.onCompleted()
                                })
                                
                            }else {
                                DispatchQueue.main.async(execute: {
                                    observer.onError(YSNetWorkError.networkError(-2, "数据错误"))
                                })
                            }

                        }catch {
                            DispatchQueue.main.async(execute: {
                                observer.onError(error)
                            })
                        }
                    }

                case let .failure(error):

                    DispatchQueue.main.async(execute: {
                        observer.onError(YSNetWorkError.networkError(error._code, error.response?.description ?? "网络内部错误"))
                    })
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }

    public func validateResponse(_ response: Moya.Response) throws -> JSON {
        
//        guard response.statusCode == 200 else {
//            throw YSNetWorkError.networkError(-1, "网络请求错误")
//        }
        
        let json = JSON(data: response.data)
        print("\(String(describing: response.request?.url?.absoluteString))请求返回返回数据:\(response.data.ys.utf8String())\n\n")
        if let code = json["retcode"].int, code == 0 {
            return json
        }else if let code = json["retcode"].int, let msg = json["message"].string {
            throw YSNetWorkError.serverError(code, msg)
        }else {
            throw YSNetWorkError.serverError(-2, "数据错误")
        }
        
    }

    
}
