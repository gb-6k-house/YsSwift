/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/
import UIKit
import SnapKit
import RxSwift

typealias YSCellExpandedHandler = ((YSBaseTableViewCell, Bool) -> Void)


open class YSBaseTableViewCell: UITableViewCell {
    
    var animationGroup: CAAnimationGroup = CAAnimationGroup()
    var disPlayLink: CADisplayLink = CADisplayLink()
    var touchPoint: CGPoint = CGPoint(x: 0, y: 0)
    var isAnimation: Bool = false
    fileprivate var circleLayer: CALayer = CALayer()
    // 上下线条
    fileprivate var didSetup = false
    fileprivate var topLine: UIView = UIView()
    fileprivate var bottomLine: UIView = UIView()

    var cellIndex: Int = 0

    typealias Confige = YSBaseTableViewConfig

     public var showTopLine = false {
        didSet {
            if !didSetup { return }
            self.layoutLines()
        }
    }

    public var topLineInset = UIEdgeInsets.zero {
        didSet {
            if !didSetup { return }
            self.layoutLines()
        }
    }
    public  var showBottomLine = false {
        didSet {
            if !didSetup { return }
            self.layoutLines()
        }
    }
    public var bottomLineInset = UIEdgeInsets.zero {
        didSet {
            if !didSetup { return }
            self.layoutLines()
        }
    }
    // 上下线条

    /// 当cell可以扩展时 注册此回调用于通知
    var expandedHandler: YSCellExpandedHandler?
    var expanded = false {
        didSet {
            guard let handler = expandedHandler else { return }
            handler(self, expanded)
        }
    }

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    open func setup() {

        self.clipsToBounds = true
        self.selectionStyle = .none
        _ = self.rx.observe(UITableViewCellAccessoryType.self, "accessoryType").takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self](accessoryType) in
                guard let `self` = self, let type = accessoryType else {
                    return
                }
                switch type {
                case .none:
                    self.accessoryView = nil
                case .disclosureIndicator:
                    if let image = YSBaseTableViewConfig.arrowImage {
                        let view = UIImageView(frame: CGRect(x: 0, y: 0, width:image.size.width, height: image.size.height))
                        view.ys.handleTheme { [unowned view] in
                            view.image = image
                        }
                        self.accessoryView = view
                    }
                default:
                    break
                }
                
            })
        
        // config
        self.contentView.ys.handleTheme { [unowned self] in
            self.contentView.backgroundColor = Confige.backgroundColor
        }
        

        self.textLabel?.ys.customize { (view) in
            view.font = Confige.textFont

            view.ys.handleTheme { [unowned view] in
                view.textColor = Confige.textColor
            }
        }

        self.detailTextLabel?.ys.customize { (view) in
            view.font = Confige.detailFont

            view.ys.handleTheme { [unowned view] in
                view.textColor = Confige.detailColor
            }
        }

        self.topLine.ys.customize { (view) in
            view.layer.zPosition += 1

            view.ys.handleTheme { [unowned view] in
                view.backgroundColor = Confige.lineColor
            }

            self.contentView.addSubview(view)
        }

        self.bottomLine.ys.customize { (view) in
            view.layer.zPosition += 1

            view.ys.handleTheme { [unowned view] in
                view.backgroundColor = Confige.lineColor
            }

            self.contentView.addSubview(view)
        }

        // layout
        self.contentView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalTo(self)
            make.width.equalTo(UI.screenWidth).priority(999)
        }

        self.contentView.setContentHuggingPriority(999, for: .vertical)
//        self.contentView.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        self.contentView.setContentHuggingPriority(999, for: .horizontal)
        self.contentView.setContentCompressionResistancePriority(999, for: .horizontal)


        self.didSetup = true

        self.layoutLines()
    }

    fileprivate func layoutLines() {

        self.topLine.isHidden = !self.showTopLine

        self.topLine.snp.remakeConstraints { (make) in
            make.top.equalTo(self.contentView)
            make.leading.equalTo(self.contentView).offset(self.topLineInset.left).priority(999)
            make.trailing.equalTo(self.contentView).offset(-self.topLineInset.right).priority(999)
            make.height.equalTo(UI.splitWidth).priority(999)
        }

        self.bottomLine.isHidden = !self.showBottomLine

        self.bottomLine.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self.contentView)
            make.leading.equalTo(self.contentView).offset(self.bottomLineInset.left + 8).priority(999)
            make.trailing.equalTo(self.contentView).offset(-self.bottomLineInset.right - 8).priority(999)
            make.height.equalTo(UI.splitWidth).priority(999)
        }

        self.setNeedsLayout()
    }

    func updateSelf() {

        var sv = self.superview

        while sv != nil {
            if sv is UITableView {
                break
            }

            sv = sv!.superview
        }

        guard let tableView = sv as? UITableView ,
            tableView.indexPath(for: self) != nil else {
            return
        }

        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.endUpdates()
        }

    }

    override open func layoutSubviews() {
        super.layoutSubviews()
    }
}

open class YSValue1Cell: YSBaseTableViewCell {
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func setup() {
        super.setup()

    }
}

open class YSValue2Cell: YSBaseTableViewCell {
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
   open override func setup() {
        super.setup()

    }
}

open class YSSubtitleCell: YSBaseTableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func setup() {
        super.setup()

    }
}


struct YSBaseTableViewConfig {
    
   static var backgroundColor: UIColor = UIColor(0xE4E4E4FF)
   static var lineColor: UIColor = UIColor(0xE4E4E4FF)
   static var textColor: UIColor = UIColor(0x484A5BFF)
   static var detailColor: UIColor = UIColor(0x484A5B7F)
    static var textFont: UIFont = UIFont.systemFont(ofSize: 16)
    static var detailFont: UIFont = UIFont.systemFont(ofSize: 14)
    static var arrowImage:UIImage?

}

