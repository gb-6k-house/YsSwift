/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(www.yourshares.cn). All rights reserved
 ******************************************************************************/

import UIKit

#if YSSWIFT_DEBUG
    import YsSwift
#endif

public protocol ServerTrust {
    var trustedHosts: Set<String>?{get set}

}


final internal class LoaderSessionDelegate: SessionDelegate, ServerTrust {
    var trustedHosts: Set<String>?
    public static let shared = LoaderSessionDelegate()
    
    private override init() {
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust, let serverTrust = challenge.protectionSpace.serverTrust ,let trustedHosts = self.trustedHosts, trustedHosts.contains(challenge.protectionSpace.host) {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
            return
            
        }
        completionHandler(.performDefaultHandling, nil)
    }
    
    
}

