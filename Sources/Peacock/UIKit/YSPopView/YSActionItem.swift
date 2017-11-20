/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import UIKit

public typealias YSActionHandler = ((_ index: Int) -> Void)

public enum YSactionItemstatus: Int {
    case normal
    case highlighted
    case disabled
}

public struct YSActionItem {

    var title: String
    var action: YSActionHandler?
    var status: YSactionItemstatus
    var image: UIImage?
    var noticeText: String?
    var mutiSelected: Bool?

    public init(
        title: String = "",
        action: YSActionHandler? = nil,
        status: YSactionItemstatus = .normal,
        image: UIImage? = nil,
        mutiSelected: Bool? = false
    ) {
        self.title = title
        self.status = status
        self.action = action
        self.image = image
        self.mutiSelected = mutiSelected
    }
}
