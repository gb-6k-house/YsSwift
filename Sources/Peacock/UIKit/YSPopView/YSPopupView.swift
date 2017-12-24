/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import SnapKit

public enum YSPopupType: Int {
    case alert
    case sheet
    case drop
    case custom
    case none
}

protocol YSPopupable {

    /**
     *  override this method to show the keyboard if with a keyboard
     */
    func showKeyboard()

    /**
     *  override this method to hide the keyboard if with a keyboard
     */
    func hideKeyboard()

    /**
     *  override this method to provide custom show animation
     */
    func showAnimation(completion closure: ((_ popupView: YSPopupView, _ finished: Bool) -> Void)?)

    /**
     *  override this method to provide custom hide animation
     */
    func hideAnimation(completion closure: ((_ popupView: YSPopupView, _ finished: Bool) -> Void)?)
}

open class YSPopupView: UIView, YSPopupable {

    fileprivate struct YSPopupNotification {
        static let hideAll = "YSPopupViewHideAllNotification"
    }

    var visible: Bool {
        if self.targetView != nil {
            return !self.targetView!.YS_dimBackgroundView.isHidden
        } else {
            return false
        }
    }

    var targetView: UIView?
    var type: YSPopupType = .custom
    var duration: TimeInterval = 0.3
    var withKeyboard: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyHideAll(_:)), name: Notification.Name(rawValue: YSPopupNotification.hideAll), object: nil)

        self.targetView = YSPopupWindow
        self.clipsToBounds = true
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: YSPopupNotification.hideAll), object: nil)
    }

    @objc fileprivate func notifyHideAll(_ n: Notification) {
        guard let cls: AnyClass = n.object as! AnyClass? else {
            return
        }

        if self.isKind(of: cls) {
            self.hide()
        }
    }

    /**
     *  show the popup view with completiom block
     */
    open func show(completion closure: ((_ popupView: YSPopupView, _ finished: Bool) -> Void)? = nil) {

        if self.targetView == nil {
            self.targetView = YSPopupWindow
        }
        self.targetView?.YS_showDimBackground()

        self.showAnimation(completion: closure)

        if self.withKeyboard {
            self.showKeyboard()
        }
    }

    /**
     *  hide the popup view with completiom block
     */
    open func hide(completion closure: ((_ popupView: YSPopupView, _ finished: Bool) -> Void)? = nil) {

        if self.targetView == nil {
            self.targetView = YSPopupWindow
        }
        self.targetView?.YS_hideDimBackground()

        self.hideAnimation(completion: closure)

        if self.withKeyboard {
            self.hideKeyboard()
        }
    }

    /**
     *  hide all popupview with current class, eg. YSAlertview.hideAll()
     */
    open static func hideAll() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: YSPopupNotification.hideAll), object: self.self)
    }
    func showKeyboard() {

    }

    func hideKeyboard() {

    }

    func showAnimation(completion closure: ((_ popupView: YSPopupView, _ finished: Bool) -> Void)?) {

        if self.superview == nil {
            self.targetView!.YS_dimBackgroundView.addSubview(self)
        }

        switch self.type {
        case .alert:
            self.snp.updateConstraints({ (make) in
                let y = self.withKeyboard ? (-216 / 2 ) : 0
                make.centerY.equalTo(self.targetView!).offset(y)
                make.centerX.equalTo(self.targetView!)
            })
//            self.layoutIfNeeded()

            self.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.0)
            self.alpha = 0.0

            UIView.animate(
                withDuration: self.duration,
                delay: 0.0,
                options: [
                    UIViewAnimationOptions.curveEaseOut,
                    UIViewAnimationOptions.beginFromCurrentState
                ],
                animations: {
                    self.layer.transform = CATransform3DIdentity
                    self.alpha = 1.0
                },
                completion: { (finished: Bool) in
                    if let completionClosure = closure {
                        completionClosure(self, finished)
                    }
            })
        case .sheet:
            self.snp.updateConstraints({ (make) in
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
        case .drop:
            self.snp.updateConstraints({ (make) in
                make.centerX.equalTo(self.targetView!)
                make.top.equalTo(self.targetView!.snp.top)
            })
            self.layoutIfNeeded()
            self.transform = CGAffineTransform(translationX: 0, y: -self.targetView!.frame.height)

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
        case .custom:
            self.snp.updateConstraints({ (make) in
                let y = self.withKeyboard ? (-216 / 2) : 0
                make.centerY.equalTo(self.targetView!).offset(y)
                make.centerX.equalTo(self.targetView!)
            })
            self.layoutIfNeeded()

            self.transform = CGAffineTransform(translationX: 0, y: -self.targetView!.frame.height)

            UIView.animate(
                withDuration: self.duration,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 1.5,
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
            break
        default:
            break
        }
    }

    func hideAnimation(completion closure: ((_ popupView: YSPopupView, _ finished: Bool) -> Void)?) {

        switch self.type {
        case .alert:
            UIView.animate(
                withDuration: self.duration,
                delay: 0.0,
                options: [
                    UIViewAnimationOptions.curveEaseIn,
                    UIViewAnimationOptions.beginFromCurrentState
                ],
                animations: {
                    self.alpha = 0.0
                },
                completion: { (finished: Bool) in
                    if finished {
                        self.removeFromSuperview()
                    }
                    if let completionClosure = closure {
                        completionClosure(self, finished)
                    }
            })
            break
        case .sheet:
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
        case .drop:

            UIView.animate(
                withDuration: self.duration,
                delay: 0.0,
                options: [
                    UIViewAnimationOptions.curveEaseIn,
                    UIViewAnimationOptions.beginFromCurrentState
                ],
                animations: {
                    self.transform = CGAffineTransform(translationX: 0, y: -self.targetView!.frame.height)
                },
                completion: { (finished: Bool) in
                    if finished {
                        self.removeFromSuperview()
                    }
                    if let completionClosure = closure {
                        completionClosure(self, finished)
                    }
            })
        case .custom:
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
        default:
            break
        }
    }
}
