/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import Moya


public class MyTarget: TargetType {
//    private var _method: Moya.Method
    public var baseURL: URL
    public var path: String = ""
    public var parameters: [String: Any]?
    public var sampleData: Data = Data()
    public var task: Task = Task.requestPlain
    public var validate: Bool {
        return false
    }
    public var method: Moya.Method {
       return .get
        
    }
    public var headers: [String: String]?
    public init(
        baseURL: URL,
        path: String = "",
        method: Moya.Method = .get,
        parameters: [String: Any]? = nil,
        sampleData: Data = Data(),
        task: Task = Task.requestPlain
        ) {
        self.path = path
        //        self.method = method
//        self._method = method
        self.parameters = parameters
        self.sampleData = sampleData
        self.baseURL = baseURL
        self.task = task
    }

}

public class YSTargetRequest: TargetType {
    public var baseURL: URL
    
//    public var baseURL: URL? = nil
    public var path: String = ""
    public var parameters: [String: Any]?
    public var sampleData: Data = Data()
    public var task: Task = Task.requestPlain
    public var validate: Bool {
        return false
    }
    public var method: Moya.Method {
        //        return self.api.method
        return .get
    }
    public var headers: [String: String]?
    public init(
        baseURL: URL,
        path: String = "",
        method: Moya.Method = .get,
        parameters: [String: Any]? = nil,
        sampleData: Data = Data(),
        task: Task = Task.requestPlain
        ) {
        self.path = path
//        self.method = method
        self.parameters = parameters
        self.sampleData = sampleData
        self.baseURL = baseURL
        self.task = task
    }
}

public class YSStructTarget: TargetType {
    fileprivate(set) var api: TargetType
    
    public init(_ api: TargetType) {
        self.api = api
    }
    
    public var path: String {
        return self.api.path
    }
    // 获取基本的url，每次发生地址变更时，替换这个url
    public var baseURL: URL {
        
        return self.api.baseURL
    }
    public var method: Moya.Method {
//        return self.api.method
        return .get
    }
    public var sampleData: Data {
        return self.api.sampleData
    }
    public var task: Task {
//        return self.api.task
        return Task.requestPlain
    }
    public var validate: Bool {
        return self.api.validate
    }
    public var headers: [String: String]? {
        return self.api.headers
    }
}

public protocol YSTargetRequestable: TargetType {
    
    var api: YSTargetRequest {get}
    
}


