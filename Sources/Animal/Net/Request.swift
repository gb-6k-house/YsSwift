/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  封装 image 请求的 URL
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import Foundation

public struct Request {
    
    fileprivate var container: Container

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

    fileprivate class Container {
        var resource: Resource
        var urlString: String? // memoized absoluteString
        
        init(resource: Resource) {
            self.resource = resource
        }
        
        func copy() -> Container {
            let ref = Container(resource: resource)
            ref.urlString = urlString
            return ref
        }
    }
    
    fileprivate enum Resource {
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
