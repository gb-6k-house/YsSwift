/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/


import UIKit

extension UIImage {

    /// iOS截图，使用WKWebView截图会有问题
    ///
    /// - Parameter view: 显示图片View
    /// - Returns: 截取图片
    open static func screenShot(_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        view.layer.render(in: context)
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return capturedImage
    }
    
    /// 截取图片到指定大小
    open static func removeImageBorder(_ image: UIImage) -> UIImage? {
        let rectWidth = (image.size.width - 2) * image.scale
        let rectHeight = (image.size.height - 8) * image.scale
        guard let imageRef = image.cgImage?.cropping(to: CGRect(x: 1 * image.scale, y: 1 * image.scale, width: rectWidth, height: rectHeight)) else {
            return nil
        }
        let newImage = UIImage(cgImage: imageRef)
        return newImage
    }
    
    // 压缩图片到指定尺寸
    open class func resizeImage(image: UIImage, size: CGSize) -> UIImage {
        // 图片尺寸 1:2
        let imageScale: CGFloat = image.size.width / image.size.height
        
        let scaleHeight: CGFloat = size.height
        let scaleWidth = scaleHeight * imageScale      // 指定图片高度，宽度按照图片的比例缩放，不然图片会变形
        
        // 图片高度大于指定高度才压缩
        guard image.size.height > scaleHeight else {
            return image
        }
        
        UIGraphicsBeginImageContext(CGSize(width: scaleWidth, height: scaleHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: scaleWidth, height: scaleHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // 获取失败，返回原图
        guard let myNewImage = newImage else {
            return image
        }
        return myNewImage
    }
    
    
    
    /// 压缩图片到指定大小,如100K
    ///
    /// - Parameters:
    ///   - img: 原始图片
    ///   - length: 压缩到指定大小
    /// - Returns: 返回的data
   open  class func compressImageDataLength(img: UIImage, length: Int) -> Data? {
        var data: Data
        var dep: CGFloat = 1.0
        repeat {
            guard let mydata = UIImageJPEGRepresentation(img, dep) else {
                return nil
            }
            data = mydata
            dep = dep - 0.1
        } while(dep > 0 && data.count >= length)
        return data
    }
}


