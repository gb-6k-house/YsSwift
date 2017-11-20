/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import Foundation
import MobileCoreServices
import RxSwift
import UIKit
import AVFoundation

enum YSMediaPickerAction {
	case photo(observer: AnyObserver<(UIImage, UIImage?)>)
	case video(observer: AnyObserver<URL>, maxDuration: TimeInterval)
}

public enum YSMediaPickerError: Error {
	case generalError
	case canceled
	case videoMaximumDurationExceeded
}

@objc public protocol YSMediaPickerDelegate {
	func presentPicker(_ picker: UIImagePickerController)
	func dismissPicker(_ picker: UIImagePickerController)
}

@objc open class YSMediaPicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	weak var delegate: YSMediaPickerDelegate?

	fileprivate var currentAction: YSMediaPickerAction?

	open var deviceHasCamera: Bool {
		return UIImagePickerController.isSourceTypeAvailable(.camera)
	}

	public init(delegate: YSMediaPickerDelegate) {
		self.delegate = delegate
	}

	open func recordVideo(device: UIImagePickerControllerCameraDevice = .rear, quality: UIImagePickerControllerQualityType = .typeMedium, maximumDuration: TimeInterval = 600, editable: Bool = false) -> Observable<URL> {

		return Observable.create { observer in
			self.currentAction = YSMediaPickerAction.video(observer: observer, maxDuration: maximumDuration)

			let picker = UIImagePickerController()
			picker.sourceType = .camera
			picker.mediaTypes = [kUTTypeMovie as String]
			picker.videoMaximumDuration = maximumDuration
			picker.videoQuality = quality
			picker.allowsEditing = editable
			picker.delegate = self

			if UIImagePickerController.isCameraDeviceAvailable(device) {
				picker.cameraDevice = device
			}

			self.delegate?.presentPicker(picker)

			return Disposables.create()
		}
	}

	open func selectVideo(_ source: UIImagePickerControllerSourceType = .photoLibrary, maximumDuration: TimeInterval = 600, editable: Bool = false) -> Observable<URL> {

		return Observable.create({ observer in
			self.currentAction = YSMediaPickerAction.video(observer: observer, maxDuration: maximumDuration)

			let picker = UIImagePickerController()
			picker.sourceType = source
			picker.mediaTypes = [kUTTypeMovie as String]
			picker.allowsEditing = editable
			picker.delegate = self

			self.delegate?.presentPicker(picker)

			return Disposables.create()
		})
	}

    
	/// 拍摄推按
	///
	/// - Parameters:
	///   - device: 使用后置摄像头
	///   - flashMode: 是否开启闪光灯
	///   - editable: 是否允许编辑
	/// - Returns: 返回的原图和被编辑的图片
	open func takePhoto(device: UIImagePickerControllerCameraDevice = .rear, flashMode: UIImagePickerControllerCameraFlashMode = .auto, editable: Bool = false) -> Observable<(UIImage, UIImage?)> {

		return Observable.create({ observer in
			self.currentAction = YSMediaPickerAction.photo(observer: observer)

			let picker = UIImagePickerController()
			picker.sourceType = .camera
			picker.allowsEditing = editable
			picker.delegate = self

			if UIImagePickerController.isCameraDeviceAvailable(device) {
				picker.cameraDevice = device
			}

			if UIImagePickerController.isFlashAvailable(for: picker.cameraDevice) {
				picker.cameraFlashMode = flashMode
			}

			self.delegate?.presentPicker(picker)

			return Disposables.create()
		})
	}

    
	/// 从相册中选择图片
	///
	/// - Parameters:
	///   - source: 源类型，选择图片
	///   - editable: 是否可以编辑
	/// - Returns: 被观察者，包含原始图片和被编辑的图片
	open func selectImage(_ source: UIImagePickerControllerSourceType = .photoLibrary, editable: Bool = false) -> Observable<(UIImage, UIImage?)> {

		return Observable.create { observer in
			self.currentAction = YSMediaPickerAction.photo(observer: observer)

			let picker = UIImagePickerController()
			picker.sourceType = source
			picker.allowsEditing = editable
			picker.delegate = self

			self.delegate?.presentPicker(picker)

			return Disposables.create()
		}
	}

	func processPhoto(_ info: [String: Any], observer: AnyObserver<(UIImage, UIImage?)>) {
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let originImage = fixOrientation(image)
			let editedImage: UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage
			observer.on(.next(originImage, editedImage))
			observer.on(.completed)
		} else {
			observer.on(.error(YSMediaPickerError.generalError))
		}
	}

    /**
     照片竖拍  web显示旋转解决:图片大于2M会自动旋转90度
     - parameter aImage: origin image
     - returns: rotate image
     */
    func fixOrientation(_ aImage: UIImage) -> UIImage {
        if aImage.imageOrientation == UIImageOrientation.up {
            return aImage
        }

        var transform = CGAffineTransform.identity

        switch aImage.imageOrientation {
            case .down, .downMirrored:
                transform = transform.translatedBy(x: aImage.size.width, y: aImage.size.height)
                transform = transform.rotated(by: CGFloat(Double.pi))
                break

            case .left, .leftMirrored:
                transform = transform.translatedBy(x: aImage.size.width, y: 0)
                transform = transform.rotated(by: CGFloat(Double.pi / 2))
                break

            case .right, .rightMirrored:
                transform = transform.translatedBy(x: 0, y: aImage.size.height)
                transform = transform.rotated(by: CGFloat(-Double.pi / 2))
                break
            default:
                break
        }

        switch aImage.imageOrientation {
            case .upMirrored, .downMirrored:
                transform = transform.translatedBy(x: aImage.size.width, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
                break

            case .leftMirrored, .rightMirrored:
                transform = transform.translatedBy(x: aImage.size.height, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
                break
            default:
                break
        }

        let ctx: CGContext = CGContext(data: nil, width: Int(aImage.size.width), height: Int(aImage.size.height),
                                                     bitsPerComponent: aImage.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                                     space: aImage.cgImage!.colorSpace!,
                                                     bitmapInfo: 1)!

        ctx.concatenate(transform)
        switch aImage.imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(aImage.cgImage!, in: CGRect(x: 0, y: 0, width: aImage.size.height, height: aImage.size.width))
                break

            default:
                ctx.draw(aImage.cgImage!, in: CGRect(x: 0, y: 0, width: aImage.size.width, height: aImage.size.height))
                break
        }

        let cgimg: CGImage = ctx.makeImage()!
        let img: UIImage = UIImage(cgImage: cgimg)
        return img
    }

	func processVideo(_ info: [String: Any], observer: AnyObserver<URL>, maxDuration: TimeInterval, picker: UIImagePickerController) {

		guard let videoURL = info[UIImagePickerControllerMediaURL] as? URL else {
			observer.on(.error(YSMediaPickerError.generalError))
			dismissPicker(picker)
			return
		}

		if let editedStart = info["_UIImagePickerControllerVideoEditingStart"] as? NSNumber,
			let editedEnd = info["_UIImagePickerControllerVideoEditingEnd"] as? NSNumber {

				let start = Int64(editedStart.doubleValue * 1000)
				let end = Int64(editedEnd.doubleValue * 1000)
				let cachesDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
				let editedVideoURL = URL(fileURLWithPath: cachesDirectory).appendingPathComponent("\(UUID().uuidString).mov", isDirectory: false)
				let asset = AVURLAsset(url: videoURL)

				if let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) {
					exportSession.outputURL = editedVideoURL
					exportSession.outputFileType = AVFileTypeQuickTimeMovie
					exportSession.timeRange = CMTimeRange(start: CMTime(value: start, timescale: 1000), duration: CMTime(value: end - start, timescale: 1000))

					exportSession.exportAsynchronously(completionHandler: {
						switch exportSession.status {
						case .completed:
							self.processVideoURL(editedVideoURL, observer: observer, maxDuration: maxDuration, picker: picker)
						case .failed: fallthrough
						case .cancelled:
							observer.on(.error(YSMediaPickerError.generalError))
							self.dismissPicker(picker)
						default: break
						}
					})
				}
		} else {
				processVideoURL(videoURL, observer: observer, maxDuration: maxDuration, picker: picker)
		}
	}

	fileprivate func processVideoURL(_ url: URL, observer: AnyObserver<URL>, maxDuration: TimeInterval, picker: UIImagePickerController) {

		let asset = AVURLAsset(url: url)
		let duration = CMTimeGetSeconds(asset.duration)

		if duration > maxDuration {
			observer.on(.error(YSMediaPickerError.videoMaximumDurationExceeded))
		} else {
			observer.on(.next(url))
			observer.on(.completed)
		}

		dismissPicker(picker)
	}

	fileprivate func dismissPicker(_ picker: UIImagePickerController) {
		delegate?.dismissPicker(picker)
	}

	// UIImagePickerControllerDelegate

	open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

		if let action = currentAction {
			switch action {
			case .photo(let observer):
				processPhoto(info as [String : AnyObject], observer: observer)
				dismissPicker(picker)
			case .video(let observer, let maxDuration):
				processVideo(info as [String : AnyObject], observer: observer, maxDuration: maxDuration, picker: picker)
			}
		}
	}

	open func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismissPicker(picker)

		if let action = currentAction {
			switch action {
			case .photo(let observer): observer.on(.error(YSMediaPickerError.canceled))
			case .video(let observer, _): observer.on(.error(YSMediaPickerError.canceled))
			}
		}
	}
}
