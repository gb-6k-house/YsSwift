/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  UIImage扩展功能
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/


import UIKit

extension YSSwift where Base: UIImage {
    /// Returns cost for the given image by approximating its bitmap size in bytes in memory.
    public var memSize: Int {
        guard let cgImage = self.base.cgImage else { return 1 }
        return cgImage.bytesPerRow * cgImage.height

    }
    
    /// 压缩图片到指定大小,如100K
    ///
    /// - Parameters:
    ///   - length: 压缩到指定大小
    /// - Returns: 返回的data
    public func compressImage(length: Int) -> Data? {
        var data: Data
        var dep: CGFloat = 1.0
        repeat {
            guard let mydata = UIImageJPEGRepresentation(self.base, dep) else {
                return nil
            }
            data = mydata
            dep = dep - 0.1
        } while(dep > 0 && data.count >= length)
        return data
    }
    
    //use this function to resize image to specify size.
    //return the new image if success else return the original image
    public func resizeImage(size: CGSize) -> UIImage {
        let image =  self.base
        let imageScale: CGFloat = image.size.width / image.size.height
        
        let scaleHeight: CGFloat = size.height
        let scaleWidth = scaleHeight * imageScale      // 指定图片高度，宽度按照图片的比例缩放，不然图片会变形
        
        // if image heigth is lower than spceiy hegiht, then return no resized image
        guard image.size.height > scaleHeight else {
            return  image
        }
        
        UIGraphicsBeginImageContext(CGSize(width: scaleWidth, height: scaleHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: scaleWidth, height: scaleHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // error
        guard let myNewImage = newImage else {
            return  image
        }
        return myNewImage
    }

    
    
}


