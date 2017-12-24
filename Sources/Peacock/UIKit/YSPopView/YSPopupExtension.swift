/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/


import UIKit

public extension UIColor {
	static func YS_hexColor(_ rgba: UInt32) -> UIColor {
		let d = CGFloat(255)
		let r = CGFloat(Int(rgba >> 24) & 0xFF) / d
		let g = CGFloat(Int(rgba >> 16) & 0xFF) / d
		let b = CGFloat(Int(rgba >> 8)  & 0xFF) / d
		let a = CGFloat(rgba & 0xFF) / d

		return UIColor(red: r, green: g, blue: b, alpha: a)
	}
}

public extension UIImage {
	static func YS_image(_ color: UIColor, size: CGSize = CGSize(width: 4, height: 4)) -> UIImage {

		let rect = CGRect(origin: CGPoint.zero, size: size)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()

		context?.setFillColor(color.cgColor)
		context?.fill(rect)

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image!
	}
}

extension UIView {

	fileprivate struct YSDimBackgroundKey {
		static var view = "view"
		static var animating = "animating"
		static var duration = "dutaion"
		static var reference = "reference"
		static var enabled = "enabled"
		static var touchWild = "touchWild"
		static var normal = "normal"
		static var highlighted = "highlighted"
	}

	func YS_showDimBackground() {

		self.YS_dimReferenceCount = self.YS_dimReferenceCount + 1

		if self.YS_dimReferenceCount > 1 {
			return
		}

		if self.isKind(of: YSWindow.self) {
			self.isHidden = false
		} else if self.isKind(of: UIWindow.self) {
			if let window = UIApplication.shared.delegate?.window {
				if self == window {
					return
				}
			}

			self.isHidden = false
		} else {
			self.bringSubview(toFront: self.YS_dimBackgroundView)
		}

		self.YS_dimBackgroundAnimating = true
		self.YS_dimBackgroundView.isHidden = false

		UIView.animate(
			withDuration: self.YS_dimBackgroundAnimatingDuration,
			delay: 0.0,
			options: [
				UIViewAnimationOptions.curveEaseOut,
				UIViewAnimationOptions.beginFromCurrentState
			],
			animations: {
				self.YS_dimBackgroundView.layer.backgroundColor = UIColor.YS_hexColor(self.YS_dimBackgroundEnabled ? 0x0000007F : 0xFFFFFF00).cgColor
			},
			completion: { (finished: Bool) in
				if finished {
					self.YS_dimBackgroundAnimating = false
				}
		})
	}

	func YS_hideDimBackground() {

		self.YS_dimReferenceCount = self.YS_dimReferenceCount - 1

		if self.YS_dimReferenceCount > 0 {
			return
		}
		self.YS_dimBackgroundAnimating = true

		UIView.animate(
			withDuration: self.YS_dimBackgroundAnimatingDuration,
			delay: 0.0,
			options: [
				UIViewAnimationOptions.curveEaseIn,
				UIViewAnimationOptions.beginFromCurrentState
			],
			animations: {
				self.YS_dimBackgroundView.layer.backgroundColor = UIColor.YS_hexColor(0x00000000).cgColor
			},
			completion: { (finished: Bool) in
				if finished {
					self.YS_dimBackgroundAnimating = false
					self.YS_dimBackgroundView.isHidden = true

					if self.isKind(of: UIWindow.self) {

						if self.isKind(of: YSWindow.self) {
							self.isHidden = true
						}

						if let window = UIApplication.shared.delegate?.window {
							if self == window {
								return
							}

							self.isHidden = true
						}
					}
				}
		})
	}

	var YS_dimReferenceCount: Int {
		get {
			return objc_getAssociatedObject(self, &YSDimBackgroundKey.reference) as? Int ?? 0
		}
		set {
			objc_setAssociatedObject(self, &YSDimBackgroundKey.reference, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	var YS_dimBackgroundView: YSGestureView {
		get {
			guard let backView = objc_getAssociatedObject(self, &YSDimBackgroundKey.view) as? YSGestureView else {
				let view = YSGestureView()
				self.addSubview(view)
				view.isHidden = true
				view.snp.makeConstraints({ (make) in
					make.edges.equalTo(self)
				})
				view.backgroundColor = UIColor.YS_hexColor(0x00000000)
				view.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
				view.layoutIfNeeded()

				objc_setAssociatedObject(self, &YSDimBackgroundKey.view, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

				let gesture = UITapGestureRecognizer(target: self, action: #selector(YS_actionTapWild))
				gesture.cancelsTouchesInView = false
				gesture.delegate = view

				view.addGestureRecognizer(gesture)

				return view
			}
			return backView
		}
		set {
			objc_setAssociatedObject(self, &YSDimBackgroundKey.view, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

    @objc func YS_actionTapWild() {
		if self.YS_dimTouchWildToHide && !self.YS_dimBackgroundAnimating {
			for view in self.YS_dimBackgroundView.subviews {
				if view.isKind(of: YSPopupView.self) {
					let popView = view as! YSPopupView
					popView.hide()
				}
			}
		}
	}

	var YS_dimBackgroundAnimating: Bool {
		get {
			return objc_getAssociatedObject(self, &YSDimBackgroundKey.animating) as? Bool ?? false
		}
		set {
			objc_setAssociatedObject(self, &YSDimBackgroundKey.animating, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	var YS_dimBackgroundEnabled: Bool {
		get {
			return objc_getAssociatedObject(self, &YSDimBackgroundKey.enabled) as? Bool ?? true
		}
		set {
			objc_setAssociatedObject(self, &YSDimBackgroundKey.enabled, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	var YS_dimBackgroundAnimatingDuration: TimeInterval {
		get {
			return objc_getAssociatedObject(self, &YSDimBackgroundKey.duration) as? TimeInterval ?? 0.3
		}
		set {
			objc_setAssociatedObject(self, &YSDimBackgroundKey.duration, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	var YS_dimTouchWildToHide: Bool {
		get {
			return objc_getAssociatedObject(self, &YSDimBackgroundKey.touchWild) as? Bool ?? true
		}
		set {
			objc_setAssociatedObject(self, &YSDimBackgroundKey.touchWild, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}

internal class YSGestureView: UIView, UIGestureRecognizerDelegate {

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		return touch.view! == self
	}
}
