/******************************************************************************
 ** auth: liukai
 ** date: 2017/10
 ** ver : 1.0
 ** desc:  图片数据处理类
 ** Copyright © 2017年 尧尚信息科技(www.yourshares.cn). All rights reserved
 ******************************************************************************/

import Foundation
#if YSSWIFT_DEBUG
    import YsSwift
#endif

/// Decodes image data.
public protocol DataDecoding {
    /// Decodes image data.
    func decode(data: Data, response: URLResponse) -> Image?
}

public final class DataDecoder: DataDecoding {
    //解析图片资源数据
    public func decode(data: Data, response: URLResponse) -> Image? {
        guard DataDecoder.validate(response: response) else {
            return nil
        }
        #if os(macOS)
            return NSImage(data: data)
        #else
            #if os(iOS) || os(tvOS)
                let scale = UIScreen.main.scale
            #else
                let scale = WKInterfaceDevice.current().screenScale
            #endif
            return UIImage(data: data, scale: scale)
        #endif
    }
    public init() {
        
    }
    //URLResponse返回有效性校验
    private static func validate(response: URLResponse) -> Bool {
        guard let response = response as? HTTPURLResponse else { return true }
        return (200..<300).contains(response.statusCode)
    }

}


