/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import UIKit

class YSNetWorkConstant: NSObject {

}

public enum YSNetWorkError: Error {
    case unknow
    case serverError(Int, String) //服务器返回错误
    case networkError(Int, String) //网络问题
}
