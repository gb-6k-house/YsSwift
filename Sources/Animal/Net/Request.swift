/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  封装 image 请求的 URL
 ** Copyright © 2017年 尧尚信息科技(www.yourshares.cn). All rights reserved
 ******************************************************************************/

import Foundation
import Result

public enum RequestError: Swift.Error {
    /// Indicates a response failed to decode request data.
    case decodingFailed
    /// Indicates a response failed with an invalid HTTP status code.
    case statusCode(URLResponse?)
    
}


public struct Request {
    public private(set) var container: Container
    public var urlRequest: URLRequest {
        get { return container.resource.urlRequest }
        set {
            applyMutation {
                $0.resource = Resource.request(newValue)
                $0.urlString = newValue.url?.absoluteString
            }
        }
    }
    public init(url: URL) {
        container = Container(resource: Resource.url(url))
        container.urlString = url.absoluteString
    }
    
    public init(urlRequest: URLRequest) {
        container = Container(resource: Resource.request(urlRequest))
        container.urlString = urlRequest.url?.absoluteString
    }

    private mutating func applyMutation(_ closure: (Container) -> Void) {
        //写时复制
        if !isKnownUniquelyReferenced(&container) {
            container = container.copy()
        }
        closure(container)
    }

    public class Container {
        public fileprivate(set) var resource: Resource
        public fileprivate(set) var urlString: String? // memoized absoluteString
        
        init(resource: Resource) {
            self.resource = resource
        }
        
        func copy() -> Container {
            let ref = Container(resource: resource)
            ref.urlString = urlString
            return ref
        }
    }
    public enum Resource {
        case url(URL)
        case request(URLRequest)
        
        var urlRequest: URLRequest {
            switch self {
            case let .url(url): return URLRequest(url: url) // create lazily
            case let .request(request): return request
            }
        }
    }

}


public extension Request {
    /// Compares two requests for equivalence using an `equator` closure.
    public class Key: Hashable {
        let request: Request
        let equator: (Request, Request) -> Bool
        
       public init(request: Request, equator: @escaping (Request, Request) -> Bool) {
            self.request = request
            self.equator = equator
        }
        
        /// Returns hash from the request's URL.
        public var hashValue: Int {
            return request.container.urlString?.hashValue ?? 0
        }
        
        /// Compares two keys for equivalence.
        public static func ==(lhs: Key, rhs: Key) -> Bool {
            return lhs.equator(lhs.request, rhs.request)
        }
    }
}






