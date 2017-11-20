/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(www.yourshares.cn). All rights reserved
 ******************************************************************************/

public enum YSSwiftError: Swift.Error {
    case undefined
}

// MARK: - Error Descriptions
extension YSSwiftError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .undefined:
            return "undefined errors"
        }
    }
}

