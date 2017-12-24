/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import SnapKit

open class YSAlertView: YSPopupView {

    fileprivate(set) var actionItems: [YSActionItem] = [YSActionItem]()
    fileprivate(set) var title: String = ""
    fileprivate(set) var detail: String = ""

    fileprivate let titleLabel = UILabel()
    fileprivate let detailLabel = UILabel()
    fileprivate let buttonView = UIView()
    fileprivate var buttons = [UIButton]()

    fileprivate override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience init(confirmTitle: String, detail: String, action: (() -> Void)? = { () in }) {
        self.init(frame: CGRect.zero)

        self.actionItems = [YSActionItem(title: YSAlertViewConfig.defaultTextConfirm, action: { _ in
            if let _ = action {
                action!()
            }

            })]
        self.title = confirmTitle
        self.detail = detail

        self.buildUI()
    }

    convenience init(okCancelTitle: String, detail: String, okActionTitle: String? = nil, action: @escaping () -> Void) {
        self.init(frame: CGRect.zero)

        let cancelAction = YSActionItem(
            title: YSAlertViewConfig.defaultTextCancel,
            action: nil
        )
        let okTitle = okActionTitle ?? YSAlertViewConfig.defaultTextConfirm
        let okAction = YSActionItem(
            title: okTitle,
            action: { _ in
                action()
        },
            status: .highlighted)

        self.actionItems = [cancelAction, okAction]
        self.title = okCancelTitle
        self.detail = detail

        self.buildUI()
    }

    convenience init(title: String, detail: String, actionItems: [YSActionItem]) {
        self.init(frame: CGRect.zero)

        self.actionItems = actionItems
        self.title = title
        self.detail = detail

        self.buildUI()
    }

    fileprivate func buildUI() {

        assert(self.actionItems.count > 0, "Need at least 1 action")

        self.targetView = YSAlertWindow

        typealias Config = YSAlertViewConfig

        self.type = .alert

        self.clipsToBounds = true
        self.layer.cornerRadius = Config.cornerRadius
        self.backgroundColor = Config.backgroundColor
//        self.layer.borderWidth = Config.splitWidth
//        self.layer.borderColor = Config.splitColor.CGColor

        self.snp.makeConstraints { (make) in
            make.width.equalTo(Config.width)
        }
        self.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        self.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)

        var lastAttribute = self.snp.top

        if self.title.characters.count > 0 {
            ({ (view: UILabel) in
                view.textColor = Config.titleColor
                view.text = self.title
                view.font = Config.titleFont
                view.numberOfLines = 0
                view.backgroundColor = Config.backgroundColor
                view.textAlignment = .center

                self.addSubview(view)
                }(self.titleLabel))

            self.titleLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(lastAttribute).offset(Config.innerPadding)
                make.leading.trailing.equalTo(self).inset(UIEdgeInsets(top: 0, left: Config.innerMargin, bottom: 0, right: Config.innerMargin))
            })

            lastAttribute = self.titleLabel.snp.bottom
        }

        if self.detail.characters.count > 0 {
            ({ (view: UILabel) in
                view.textColor = Config.detailColor
                view.text = self.detail
                view.font = Config.detailFont
                view.numberOfLines = 0
                view.backgroundColor = self.backgroundColor
                view.textAlignment = .center

                self.addSubview(view)
                }(self.detailLabel))

            self.detailLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(lastAttribute).offset(Config.innerPadding)
                make.leading.trailing.equalTo(self).inset(UIEdgeInsets(top: 0, left: Config.innerMargin, bottom: 0, right: Config.innerMargin))
            })

            lastAttribute = self.detailLabel.snp.bottom
        }

        ({ (view: UIView) in
            view.backgroundColor = self.backgroundColor
            view.backgroundColor = UIColor.blue

            self.addSubview(view)
            }(self.buttonView))

        self.buttonView.snp.makeConstraints { (make) in
            make.top.equalTo(lastAttribute).offset(Config.innerMargin)
            make.leading.bottom.trailing.equalTo(self)
        }

        for i in 0..<self.actionItems.count {
            let action = self.actionItems[i]

            let button: UIButton = {
                let btn = UIButton()
                btn.addTarget(self, action: #selector(actionTap(_:)), for: .touchUpInside)
                btn.tag = i
                btn.setBackgroundImage(UIImage.YS_image(Config.buttonBackgroundNormalColor), for: .normal)
                btn.setBackgroundImage(UIImage.YS_image(Config.buttonBackgroundHighlightedColor), for: .highlighted)
                btn.setBackgroundImage(UIImage.YS_image(Config.buttonBackgroundDisabledColor), for: .disabled)
                btn.setTitleColor(action.status == .highlighted ? Config.buttonTitleHighlightedColor : Config.buttonTitleNormalColor, for: .normal)
                btn.setTitleColor(Config.buttonTitleDisabledColor, for: .disabled)
                btn.setTitle(action.title, for: .normal)
                btn.layer.borderWidth = Config.splitWidth
                btn.layer.borderColor = Config.splitColor.cgColor
                btn.titleLabel?.font = Config.buttonFont

                btn.isEnabled = action.status != .disabled

                self.buttonView.addSubview(btn)
                return btn
            }()
            self.buttons.append(button)

            button.snp.makeConstraints({ (make) in
                make.height.equalTo(Config.buttonHeight)

                if self.actionItems.count < 3 { // horizontal
                    make.top.bottom.equalTo(self.buttonView)

                    if i == 0 {
                        make.leading.equalTo(self.buttonView.snp.leading).offset(-Config.splitWidth)
                    } else {
                        make.leading.equalTo(self.buttons[i - 1].snp.trailing).offset(-Config.splitWidth)
                        make.width.equalTo(self.buttons[i - 1])
                    }

                    if i == self.actionItems.count - 1 {
                        make.trailing.equalTo(self.buttonView.snp.trailing).offset(Config.splitWidth)
                    }

                } else { // vertical
                    make.leading.trailing.equalTo(self.buttonView).inset(UIEdgeInsets(top: 0, left: -Config.splitWidth, bottom: 0, right: -Config.splitWidth))

                    if i == 0 {
                        make.top.equalTo(self.buttonView.snp.top)
                    } else {
                        make.top.equalTo(self.buttons[i - 1].snp.bottom).offset(-Config.splitWidth)
                    }

                    if i == self.actionItems.count - 1 {
                        make.bottom.equalTo(self.buttonView.snp.bottom).offset(Config.splitWidth)
                    }
                }
            })

        }
    }

    @objc fileprivate func actionTap(_ btn: UIButton) {
        let action = self.actionItems[btn.tag]

        if action.status == .disabled {
            return
        }

        self.hide()

        if action.action != nil {
            action.action!(btn.tag)
        }
    }
}

public struct YSAlertViewConfig {

    static var width: CGFloat = 275.0
    static var buttonHeight: CGFloat = 42.0
    static var innerMargin: CGFloat = 18.0
    static var innerPadding: CGFloat = 12.0
    static var cornerRadius: CGFloat = 5.0
    static var splitWidth: CGFloat = 1.0 / UIScreen.main.scale

    static var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 18)
    static var detailFont: UIFont = UIFont.boldSystemFont(ofSize: 14)
    static var buttonFont: UIFont = UIFont.boldSystemFont(ofSize: 17)

    static var backgroundColor: UIColor = UIColor(0xFFFFFFFF)
    static var titleColor: UIColor = UIColor(0x333333FF)
    static var detailColor: UIColor = UIColor(0x333333FF)
    static var splitColor: UIColor = UIColor(0xCCCCCCFF)

    static var buttonTitleNormalColor: UIColor = UIColor(0x000000FF)
    static var buttonTitleHighlightedColor: UIColor = UIColor(0xFF0000FF)
    static var buttonTitleDisabledColor: UIColor = UIColor(0x999999FF)

    static var buttonBackgroundNormalColor: UIColor = UIColor(0xFFFFFFFF)
    static var buttonBackgroundHighlightedColor: UIColor = UIColor(0xCCCCCCFF)
    static var buttonBackgroundDisabledColor: UIColor = UIColor(0xAAAAAAFF)

    static var defaultTextOK: String = "OK"
    static var defaultTextCancel: String = "Cancel"
    static var defaultTextConfirm: String = "Confirm"
}
