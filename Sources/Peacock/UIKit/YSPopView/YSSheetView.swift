/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import SnapKit

open class YSSheetView: YSPopupView {
    typealias Config = YSSheetViewConfig
    fileprivate(set) var actionItems: [YSActionItem] = [YSActionItem]()
    fileprivate(set) var title: String = ""
    
    fileprivate let titleLabel = UILabel()
    fileprivate let cancelButton = UIButton()
    fileprivate let buttonView = UIView()
    fileprivate var buttons = [UIButton]()
    
    fileprivate override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience public init(title: String, actionItems: [YSActionItem]) {
        self.init(frame: CGRect.zero)
        
        self.title = title
        self.actionItems = actionItems
        
        self.buildUI()
    }
    convenience public init(actionItems: [YSActionItem]) {
        self.init(frame: CGRect.zero)
        
        self.actionItems = actionItems
        
        self.buildUI()
    }
    
    fileprivate func buildUI() {
        
        assert(self.actionItems.count > 0, "Need at least 1 action")
        
        self.targetView = YSSheetWindow
        
        
        self.type = .sheet
        
        self.backgroundColor = Config.buttonBackgroundNormalColor
        
        self.snp.makeConstraints { (make) in
            make.width.equalTo(Config.width)
        }
        self.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        self.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        var lastAttribute = self.snp.top
        
        if self.title.characters.count > 0 {
            let contentView: UIView = {
                let view = UIView()
                view.backgroundColor = Config.buttonBackgroundNormalColor
                view.layer.borderColor = Config.splitColor.cgColor
                view.layer.borderWidth = Config.splitWidth
                
                return view
            }()
            
            self.addSubview(contentView)
            contentView.snp.makeConstraints({ (make) in
                make.leading.top.trailing.equalTo(self).inset(UIEdgeInsets(top: -Config.splitWidth, left: -Config.splitWidth, bottom: 0, right: -Config.splitWidth))
            })
            
            ({ (view: UILabel) in
                view.textColor = Config.titleColor
                view.text = self.title
                view.font = Config.titleFont
                view.numberOfLines = 0
                view.backgroundColor = contentView.backgroundColor
                view.textAlignment = .center
                
                contentView.addSubview(view)
                }(self.titleLabel))
            
            self.titleLabel.snp.makeConstraints({ (make) in
                make.top.leading.bottom.trailing.equalTo(contentView).inset(UIEdgeInsets(top: Config.innerPadding, left: Config.innerPadding, bottom: Config.innerPadding, right: Config.innerPadding))
            })
            
            lastAttribute = contentView.snp.bottom
        }
        
        self.addSubview(self.buttonView)
        self.buttonView.snp.makeConstraints { (make) in
            make.top.equalTo(lastAttribute).offset(-Config.splitWidth)
            make.leading.trailing.equalTo(self)
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
                btn.setTitleColor(Config.buttonTitleNormalColor, for: .normal)
                btn.setTitleColor(Config.buttonTitleHighlightedColor, for: .highlighted)
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
                make.leading.trailing.equalTo(self.buttonView).inset(UIEdgeInsets(top: 0, left: -Config.splitWidth, bottom: 0, right: -Config.splitWidth))
                
                if i == 0 {
                    make.top.equalTo(self.buttonView.snp.top)
                } else {
                    make.top.equalTo(self.buttons[i - 1].snp.bottom).offset(-Config.splitWidth)
                }
                
                if i == self.actionItems.count - 1 {
                    make.bottom.equalTo(self.buttonView.snp.bottom).offset(Config.splitWidth)
                }
            })
        }
        
        let gapView: UIView = {
            let view = UIView()
            view.backgroundColor = Config.gapColor
            
            self.addSubview(view)
            return view
        }()
        
        gapView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(self.buttonView.snp.bottom).offset(-Config.splitWidth)
            make.height.equalTo(Config.gapWidth)
        }
        
        ({ (view: UIButton) in
            view.addTarget(self, action: #selector(actionCancel), for: .touchUpInside)
            view.setBackgroundImage(UIImage.YS_image(Config.buttonBackgroundNormalColor), for: .normal)
            view.setBackgroundImage(UIImage.YS_image(Config.buttonBackgroundHighlightedColor), for: .highlighted)
            view.setTitleColor(Config.cancelTitleNormalColor, for: .normal)
            view.setTitleColor(Config.cancelTitleHighlightedColor, for: .highlighted)
            view.setTitle(Config.defaultTextCancel, for: .normal)
            view.titleLabel?.font = Config.buttonFont
            
            self.addSubview(view)
            }(self.cancelButton))
        self.cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(gapView.snp.bottom)
            make.leading.bottom.trailing.equalTo(self)
            make.height.equalTo(Config.buttonHeight)
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
    
    @objc fileprivate func actionCancel() {
        self.hide()
    }
    
    override func showAnimation(completion closure: ((_ popupView: YSPopupView, _ finished: Bool) -> Void)?) {
        if self.superview == nil {
            self.targetView!.YS_dimBackgroundView.addSubview(self)
        }
        
        self.snp.remakeConstraints({ (make) in
            make.width.equalTo(Config.width)
            make.centerX.equalTo(self.targetView!)
            make.bottom.equalTo(self.targetView!.snp.bottom)
        })
        self.layoutIfNeeded()
        self.transform = CGAffineTransform(translationX: 0, y: self.targetView!.frame.height)
        
        UIView.animate(
            withDuration: self.duration,
            delay: 0.0,
            options: [
                UIViewAnimationOptions.curveEaseOut,
                UIViewAnimationOptions.beginFromCurrentState
            ],
            animations: {
                self.transform = CGAffineTransform.identity
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
                self.transform = CGAffineTransform(translationX: 0, y: self.targetView!.frame.height)
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

struct YSSheetViewConfig {
    
    static var width: CGFloat = UIScreen.main.bounds.width
    static var buttonHeight: CGFloat = 50.0
    static var innerPadding: CGFloat = 10.0
    static var splitWidth: CGFloat = 1.0 / UIScreen.main.scale
    static var gapWidth: CGFloat = 8
    
    static var titleFont: UIFont = UIFont.systemFont(ofSize: 14)
    static var buttonFont: UIFont = UIFont.boldSystemFont(ofSize: 17)
    
    static var titleColor: UIColor = UIColor.YS_hexColor(0x333333FF)
    static var splitColor: UIColor = UIColor.YS_hexColor(0xCCCCCCFF)
    static var gapColor: UIColor = UIColor.YS_hexColor(0xEEEEEEFF)
    
    static var buttonTitleNormalColor: UIColor = UIColor.YS_hexColor(0x000000FF)
    static var buttonTitleHighlightedColor: UIColor = UIColor.YS_hexColor(0xFF0000FF)
    static var buttonTitleDisabledColor: UIColor = UIColor.YS_hexColor(0x999999FF)
    
    static var buttonBackgroundNormalColor: UIColor = UIColor.YS_hexColor(0xFFFFFFFF)
    static var buttonBackgroundHighlightedColor: UIColor = UIColor.YS_hexColor(0xCCCCCCFF)
    static var buttonBackgroundDisabledColor: UIColor = UIColor.YS_hexColor(0xAAAAAAFF)
    
    static var cancelTitleNormalColor: UIColor = UIColor.YS_hexColor(0x000000FF)
    static var cancelTitleHighlightedColor: UIColor = UIColor.YS_hexColor(0xFF0000FF)
    
    static var defaultTextCancel: String = "Cancel"
}

