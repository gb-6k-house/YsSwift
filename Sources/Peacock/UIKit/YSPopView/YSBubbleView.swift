/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import SnapKit

enum YSBubbleDiretcion: Int {
    case top
    case left
    case bottom
    case right
    case topLeft
    case topRight
    case leftTop
    case leftBottom
    case bottomLeft
    case bottomRight
    case rightTop
    case rightBottom
    case automatic

}

open class YSBubbleView: YSPopupView {

    fileprivate(set) var cellAction: [YSActionItem] = [YSActionItem]()

    let tableView = UITableView()
    fileprivate let arrowView = UIImageView()
    fileprivate var anchorView = UIView()
    fileprivate var anchorDirection = YSBubbleDiretcion.automatic

    fileprivate var popWidth: CGFloat = 0

    fileprivate override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience init(anchorView: UIView, titles: [String], anchorDirection: YSBubbleDiretcion = .automatic, action: @escaping ((_ index: Int) -> Void), width: CGFloat) {

        var actions: [YSActionItem] = [YSActionItem]()
        for title in titles {
            let action = YSActionItem(title: title, action: action)

            actions.append(action)
        }

        self.init(anchorView: anchorView, anchorDirection: anchorDirection, cellAction: actions, width: width)
    }

    convenience init(anchorView: UIView, titles: [String], anchorDirection: YSBubbleDiretcion = .automatic, action: @escaping ((_ index: Int) -> Void)) {

        var actions: [YSActionItem] = [YSActionItem]()
        for title in titles {
            let action = YSActionItem(title: title, action: action)

            actions.append(action)
        }

        self.init(anchorView: anchorView, anchorDirection: anchorDirection, cellAction: actions, width: YSBubbleViewConfig.width)
    }

    convenience init(anchorView: UIView, anchorDirection: YSBubbleDiretcion = .automatic, cellAction: [YSActionItem]) {

        self.init(anchorView: anchorView, anchorDirection: anchorDirection, cellAction: cellAction, width: YSBubbleViewConfig.width)
    }

    convenience init(anchorView: UIView, anchorDirection: YSBubbleDiretcion = .automatic, cellAction: [YSActionItem], width: CGFloat) {

        self.init(frame: CGRect.zero)

        self.anchorView = anchorView
        self.cellAction = cellAction
        self.anchorDirection = anchorDirection
        self.popWidth = width

        if self.anchorDirection == .automatic {
            self.anchorDirection = self.getAnchorDirection(self.anchorView)
        }

        self.buildUI()
    }

    fileprivate func buildUI() {

        assert(self.cellAction.count > 0, "Need at least 1 action")

        self.targetView = YSBubbleWindow

        typealias Config = YSBubbleViewConfig

        self.type = .custom

        self.snp.makeConstraints { (make) in
            make.width.equalTo(self.popWidth)
        }
        self.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        self.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)

        ({ (view: UIImageView) in
            view.contentMode = .center
            view.image = UIImage.YS_rhombusWithSize(CGSize(width: Config.arrowWidth + Config.cornerRadius, height: Config.arrowWidth + Config.cornerRadius), color: Config.cellBackgroundNormalColor)

            self.addSubview(view)
            }(self.arrowView))

        ({ (view: UITableView) in
            view.delegate = self
            view.dataSource = self
            view.separatorStyle = .none
            view.register(YSBubbleViewCell.self, forCellReuseIdentifier: "YSBubbleViewCell")
            view.isScrollEnabled = self.cellAction.count > Config.maxNumberOfItems
            view.canCancelContentTouches = false
            view.delaysContentTouches = false
            view.backgroundColor = Config.cellBackgroundNormalColor
            view.layer.cornerRadius = Config.cornerRadius
            view.layer.masksToBounds = true
            view.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.0000001))

            self.addSubview(view)
            }(self.tableView))

        self.tableView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalTo(self).inset(UIEdgeInsets(top: Config.arrowWidth, left: Config.arrowWidth, bottom: Config.arrowWidth, right: Config.arrowWidth))

            let count = CGFloat(min(CGFloat(Config.maxNumberOfItems) + 0.5, CGFloat(self.cellAction.count)))

            make.height.equalTo(Config.cellHeight * count).priority(750)
        }

        self.layoutIfNeeded()
    }

 

    fileprivate func getAnchorWindow(_ anchorView: UIView) -> UIWindow {

        var sv = anchorView.superview

        while sv != nil {
            if sv!.isKind(of: UIWindow.self) {
                break
            }

            sv = sv!.superview
        }

        assert(sv != nil, "fatal: anchorView should be on some window")

        let window = sv as! UIWindow

        return window
    }

    fileprivate func getAnchorPosition(_ anchorView: UIView) -> CGPoint {

        let window = self.getAnchorWindow(anchorView)

        let center = CGPoint(x: anchorView.frame.width / 2.0, y: anchorView.frame.height / 2.0)

        return anchorView.convert(center, to: window)
    }

    fileprivate func getAnchorDirection(_ anchorView: UIView) -> YSBubbleDiretcion {

        let position = self.getAnchorPosition(anchorView)
        let xRatio: CGFloat = position.x / UIScreen.main.bounds.width
        let yRatio: CGFloat = position.y / UIScreen.main.bounds.height

        switch (xRatio, yRatio) {
        case (CGFloat(0.0 / 3.0)..<CGFloat(1.0 / 3.0),
            CGFloat(0.0 / 6.0)..<CGFloat(1.0 / 6.0)):
                return .topLeft
        case (CGFloat(2.0 / 3.0)...CGFloat(3.0 / 3.0),
            CGFloat(0.0 / 6.0)..<CGFloat(1.0 / 6.0)):
                return .topRight
        case (CGFloat(0.0 / 3.0)..<CGFloat(1.0 / 3.0),
            CGFloat(1.0 / 6.0)..<CGFloat(2.0 / 6.0)):
                return .leftTop
        case (CGFloat(2.0 / 3.0)...CGFloat(3.0 / 3.0),
            CGFloat(1.0 / 6.0)..<CGFloat(2.0 / 6.0)):
                return .rightTop
        case (CGFloat(0.0 / 3.0)..<CGFloat(1.0 / 3.0),
            CGFloat(2.0 / 6.0)..<CGFloat(4.0 / 6.0)):
                return .left
        case (CGFloat(2.0 / 3.0)...CGFloat(3.0 / 3.0),
            CGFloat(2.0 / 6.0)..<CGFloat(4.0 / 6.0)):
                return .right
        case (CGFloat(0.0 / 3.0)..<CGFloat(1.0 / 3.0),
            CGFloat(4.0 / 6.0)..<CGFloat(5.0 / 6.0)):
                return .leftBottom
        case (CGFloat(2.0 / 3.0)...CGFloat(3.0 / 3.0),
            CGFloat(4.0 / 6.0)..<CGFloat(5.0 / 6.0)):
                return .rightBottom
        case (CGFloat(0.0 / 3.0)..<CGFloat(1.0 / 3.0),
            CGFloat(5.0 / 6.0)...CGFloat(6.0 / 6.0)):
                return .bottomLeft
        case (CGFloat(2.0 / 3.0)...CGFloat(3.0 / 3.0),
            CGFloat(5.0 / 6.0)...CGFloat(6.0 / 6.0)):
                return .bottomRight
        case (CGFloat(1.0 / 3.0)...CGFloat(2.0 / 3.0),
            CGFloat(0.0 / 6.0)..<CGFloat(4.0 / 6.0)):
                return .top
        case (CGFloat(1.0 / 3.0)...CGFloat(2.0 / 3.0),
            CGFloat(4.0 / 6.0)...CGFloat(6.0 / 6.0)):
                return .bottom
        default:
            print("warning: anchorView is out of screen")
            return .top
        }
    }
    override func showAnimation(completion closure: ((_ popupView: YSPopupView, _ finished: Bool) -> Void)?) {
        
        if self.superview == nil {
            self.targetView!.YS_dimBackgroundView.addSubview(self)
            self.targetView!.YS_dimBackgroundView.layoutIfNeeded()
            self.targetView!.YS_dimBackgroundAnimatingDuration = 0.15
            self.duration = self.targetView!.YS_dimBackgroundAnimatingDuration
        }
        
        typealias Config = YSBubbleViewConfig
        
        let center = self.getAnchorPosition(self.anchorView)
        let widthOffset = self.anchorView.frame.size.width / 2.0
        let heightOffset = self.anchorView.frame.size.height / 2.0
        let arrowOffset = Config.arrowWidth * 2 + Config.cornerRadius
        let xOffsetRatio = arrowOffset / self.frame.width
        let yOffsetRatio = arrowOffset / self.frame.height
        
        switch self.anchorDirection {
        case .topLeft:
            self.layer.anchorPoint = CGPoint(x: xOffsetRatio, y: 0.0)
            self.layer.position = CGPoint(x: center.x, y: center.y + heightOffset)
        case .leftTop:
            self.layer.anchorPoint = CGPoint(x: 0.0, y: yOffsetRatio)
            self.layer.position = CGPoint(x: center.x + widthOffset, y: center.y)
        case .topRight:
            self.layer.anchorPoint = CGPoint(x: 1.0 - xOffsetRatio, y: 0.0)
            self.layer.position = CGPoint(x: center.x, y: center.y + heightOffset)
        case .rightTop:
            self.layer.anchorPoint = CGPoint(x: 1.0, y: yOffsetRatio)
            self.layer.position = CGPoint(x: center.x - widthOffset, y: center.y)
        case .bottomLeft:
            self.layer.anchorPoint = CGPoint(x: xOffsetRatio, y: 1.0)
            self.layer.position = CGPoint(x: center.x, y: center.y - heightOffset)
        case .leftBottom:
            self.layer.anchorPoint = CGPoint(x: 0.0, y: 1.0 - yOffsetRatio)
            self.layer.position = CGPoint(x: center.x + widthOffset, y: center.y)
        case .bottomRight:
            self.layer.anchorPoint = CGPoint(x: 1.0 - xOffsetRatio, y: 1.0)
            self.layer.position = CGPoint(x: center.x, y: center.y - heightOffset)
        case .rightBottom:
            self.layer.anchorPoint = CGPoint(x: 1.0, y: 1.0 - yOffsetRatio)
            self.layer.position = CGPoint(x: center.x - widthOffset, y: center.y)
        case .top:
            self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            self.layer.position = CGPoint(x: center.x, y: center.y + heightOffset)
        case .bottom:
            self.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            self.layer.position = CGPoint(x: center.x, y: center.y - heightOffset)
        case .left:
            self.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            self.layer.position = CGPoint(x: center.x + widthOffset, y: center.y)
        case .right:
            self.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
            self.layer.position = CGPoint(x: center.x - widthOffset, y: center.y)
        default:
            break
        }
        
        self.arrowView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 2.0 * (Config.arrowWidth + Config.cornerRadius), height: 2.0 * (Config.arrowWidth + Config.cornerRadius)))
            
            switch self.anchorDirection {
            case .topLeft:
                make.centerY.equalTo(self.tableView.snp.top)
                make.left.equalTo(self.tableView.snp.left)
            case .leftTop:
                make.centerX.equalTo(self.tableView.snp.left)
                make.top.equalTo(self.tableView.snp.top)
            case .topRight:
                make.centerY.equalTo(self.tableView.snp.top)
                make.right.equalTo(self.tableView.snp.right)
            case .rightTop:
                make.centerX.equalTo(self.tableView.snp.right)
                make.top.equalTo(self.tableView.snp.top)
            case .bottomLeft:
                make.centerY.equalTo(self.tableView.snp.bottom)
                make.left.equalTo(self.tableView.snp.left)
            case .leftBottom:
                make.centerX.equalTo(self.tableView.snp.left)
                make.bottom.equalTo(self.tableView.snp.bottom)
            case .bottomRight:
                make.centerY.equalTo(self.tableView.snp.bottom)
                make.right.equalTo(self.tableView.snp.right)
            case .rightBottom:
                make.centerX.equalTo(self.tableView.snp.right)
                make.bottom.equalTo(self.tableView.snp.bottom)
            case .top:
                make.centerY.equalTo(self.tableView.snp.top)
                make.centerX.equalTo(self.tableView.snp.centerX)
            case .bottom:
                make.centerY.equalTo(self.tableView.snp.bottom)
                make.centerX.equalTo(self.tableView.snp.centerX)
            case .left:
                make.centerY.equalTo(self.tableView.snp.centerY)
                make.centerX.equalTo(self.tableView.snp.left)
            case .right:
                make.centerY.equalTo(self.tableView.snp.centerY)
                make.centerX.equalTo(self.tableView.snp.right)
            default:
                break
            }
        }
        
        self.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1.0)
        
        UIView.animate(
            withDuration: self.duration,
            delay: 0.0,
            options: [
                UIViewAnimationOptions.curveEaseOut,
                UIViewAnimationOptions.beginFromCurrentState
            ],
            animations: {
                self.layer.transform = CATransform3DIdentity
        },
            completion: { (finished: Bool) in
                if let completionClosure = closure {
                    completionClosure(self, finished)
                }
        })
    }
    
    override func hideAnimation(completion closure: ((_ popupView: YSPopupView, _ finished: Bool) -> Void)?) {
        
        UIView.animate(
            withDuration: self.duration,
            delay: 0.0,
            options: [
                UIViewAnimationOptions.curveEaseIn,
                UIViewAnimationOptions.beginFromCurrentState
            ],
            animations: {
                self.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1.0)
        },
            completion: { (finished: Bool) in
                if finished {
                    self.removeFromSuperview()
                }
                if let completionClosure = closure {
                    completionClosure(self, finished)
                }
        })
    }
}
extension YSBubbleView: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellAction.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return YSBubbleViewConfig.cellHeight
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "YSBubbleViewCell", for: indexPath) as! YSBubbleViewCell

        let item = self.cellAction[indexPath.row]
        cell.titleLabel.text = item.title
        cell.showIcon = item.image != nil
        cell.iconView.image = item.image
        cell.split.isHidden = indexPath.row == self.cellAction.count - 1

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item = self.cellAction[indexPath.row]

        self.hide()

        if let action = item.action {
            action(indexPath.row)
        }
    }
}

private extension UIImage {

    static func YS_rhombusWithSize(_ size: CGSize, color: UIColor) -> UIImage {

        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)

        color.setFill()

        let path = UIBezierPath()
        path.move(to: CGPoint(x: size.width / 2.0, y: 0.0))
        path.addLine(to: CGPoint(x: size.width, y: size.height / 2.0))
        path.addLine(to: CGPoint(x: size.width / 2.0, y: size.height))
        path.addLine(to: CGPoint(x: 0, y: size.height / 2.0))
        path.addLine(to: CGPoint(x: size.width / 2.0, y: 0.0))
        path.close()
        path.fill()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

private class YSBubbleViewCell: UITableViewCell {

    var showIcon = false {
        didSet {
            self.iconView.isHidden = !showIcon
            self.titleLabel.snp.updateConstraints { (make) in
                make.leading.equalTo(self.iconView.snp.trailing).offset(self.showIcon ? YSBubbleViewConfig.innerPadding : -YSBubbleViewConfig.iconSize.width)
            }
        }
    }

    let iconView = UIImageView()
    let titleLabel = UILabel()
    let split = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {

        typealias Config = YSBubbleViewConfig

        self.selectionStyle = .none
        self.contentView.backgroundColor = Config.cellBackgroundNormalColor

        ({ (view: UIImageView) in

            self.contentView.addSubview(view)
            }(self.iconView))

        ({ (view: UILabel) in
            view.textColor = Config.cellTitleColor
            view.font = Config.cellTitleFont
            view.textAlignment = Config.cellTitleAlignment
            view.adjustsFontSizeToFitWidth = true

            self.contentView.addSubview(view)
            }(self.titleLabel))

        ({ (view: UIView) in
            view.backgroundColor = Config.cellSplitColor

            self.contentView.addSubview(view)
            }(self.split))

        self.iconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.leading.equalTo(self.contentView.snp.leading).offset(Config.innerPadding)
            make.size.equalTo(Config.iconSize)
        }

        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.iconView.snp.trailing).offset(self.showIcon ? Config.innerPadding : -Config.iconSize.width)
            make.top.bottom.trailing.equalTo(self.contentView).inset(UIEdgeInsets(top: 0, left: Config.innerPadding, bottom: 0, right: Config.innerPadding))
        }

        self.split.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(self.contentView)
            make.height.equalTo(Config.splitWidth)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.contentView.backgroundColor = YSBubbleViewConfig.cellBackgroundHighlightedColor
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.contentView.backgroundColor = YSBubbleViewConfig.cellBackgroundNormalColor
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.contentView.backgroundColor = YSBubbleViewConfig.cellBackgroundNormalColor
    }
}

public struct YSBubbleViewConfig {

    static var maxNumberOfItems = 5
    static var width: CGFloat = 120.0
    static var cornerRadius: CGFloat = 5.0
    static var cellHeight: CGFloat = 50.0
    static var innerPadding: CGFloat = 10.0
    static var splitWidth: CGFloat = 1.0 / UIScreen.main.scale
    static var iconSize: CGSize = CGSize(width: 25, height: 25)
    static var arrowWidth: CGFloat = 10.0

    static var cellTitleAlignment: NSTextAlignment = .left
    static var cellTitleFont: UIFont = UIFont.systemFont(ofSize: 14)
    static var cellTitleColor: UIColor = UIColor.YS_hexColor(0x333333FF)
    static var cellSplitColor: UIColor = UIColor.YS_hexColor(0xCCCCCCFF)
    static var cellBackgroundNormalColor: UIColor = UIColor.YS_hexColor(0xFFFFFFFF)
    static var cellBackgroundHighlightedColor: UIColor = UIColor.YS_hexColor(0xCCCCCCFF)
    static var cellImageColor: UIColor = UIColor.YS_hexColor(0xFFFFFFFF)
}
