/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import Moya
import RxSwift
import Result

open class YSNetWorkManager: NSObject {
    
    static let endpointClosure = { (target: YSTargetRequest) -> Moya.Endpoint<YSTargetRequest> in
        
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        
        let endpoint = Moya.Endpoint<YSTargetRequest>(
            url: url,
            sampleResponseClosure: {
                .networkResponse(200, target.sampleData)
        },
            method: target.method,
            task: target.task,
            httpHeaderFields: YSNetWorkManager.headers)
        
        return endpoint
    }
    
    static let requestClosure = { (endpoint: Moya.Endpoint<YSTargetRequest>, done: MoyaProvider<YSTargetRequest>.RequestResultClosure) in
        // Using the `as!` forced type cast operator is safe here,
        // as `mutableCopy()` will always return the correct type.
        
        if let request = endpoint.urlRequest {
            
            let r = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
            
            r.timeoutInterval = 10
            
            done(Result<URLRequest, Moya.MoyaError>.success(r as URLRequest))
        } else {
            done(Result<URLRequest, Moya.MoyaError>.failure(Moya.MoyaError.requestMapping(endpoint.url)))
        }
    }
    static var headers: [String: String]?
    
    public static func setHeaders(headers:[String: String]? ) {
        self.headers = headers
    }
    public static var provider = MoyaProvider<YSTargetRequest>(
        endpointClosure: endpointClosure,
        requestClosure: requestClosure
    )

}
