/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import UIKit
#if YSSWIFT_DEBUG
    import YsSwift
#endif


public extension UIImage {

   public static func colorImage(_ color: UIColor, size: CGSize = CGSize(width: 4, height: 4)) -> UIImage {
        
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



extension YSSwift where Base: UIImage {
    public func subImage(_ rect: CGRect) -> UIImage {
        //
        let subImageRef = self.base.cgImage?.cropping(to: rect)
        let ysallBounds = CGRect(x: 0, y: 0, width: (subImageRef?.width)!, height: (subImageRef?.height)!)
        
        UIGraphicsBeginImageContext(ysallBounds.size)
        let context = UIGraphicsGetCurrentContext()
        context?.draw(subImageRef!, in: ysallBounds)
        let ysallImage = UIImage(cgImage: subImageRef!)
        UIGraphicsEndImageContext()
        
        return ysallImage
    }
    
    public func subImage() -> UIImage {
        // 裁取正方形
        let rawWidth = self.base.size.width
        let rawHeight = self.base.size.height
        
        if rawWidth > rawHeight {
            let rect = CGRect(x: (rawWidth - rawHeight) / 2.0, y: 0, width: rawHeight, height: rawHeight)
            return self.subImage(rect)
        } else {
            let rect = CGRect(x: 0, y: (rawHeight - rawWidth) / 2.0, width: rawWidth, height: rawWidth)
            return self.subImage(rect)
        }
    }
    /**
     图片压缩，异步处理
     
     - parameter size:        最终分辨率
     - parameter maxDataSize: 图片大小kb
     - parameter handler:     成功回调
     */
    public func compressImage(_ size: CGSize, maxDataSize: Int, handler: ((_ imageData: Data?) -> Void)?) {
        DispatchQueue.global(qos: .default).async {
            let image = self.scaleImage(size)
            let data = image.ys.resetSizeToData(maxDataSize)
            DispatchQueue.main.async(execute: {
                handler?(data)
            })
        }
    }
    
    /**
     图片质量压缩到指定大小，二分
     
     - parameter maxSize: 大小kb
     
     - returns: NSData
     */
    public func resetSizeToData(_ maxSize: Int) -> Data? {
        
        // 先判断当前大小是否满足要求，不满足再进行压缩
        let data = UIImageJPEGRepresentation(self.base, 1)!
        if data.size() <= maxSize {
            return data
        }
        
        var maxQuality: CGFloat = 1
        var minQuelity: CGFloat = 0
        while maxQuality - minQuelity >= 0.01 { // 精度
            let midQuality = (maxQuality + minQuelity) / 2
            let data = UIImageJPEGRepresentation(self.base, midQuality)!
            if data.size() > maxSize {
                maxQuality = midQuality
            } else {
                minQuelity = midQuality
            }
        }
        return UIImageJPEGRepresentation(self.base, minQuelity)
    }
    
    /**
     更改分辨率
     
     - parameter size: 分辨率
     
     - returns: UIImage
     */
    public func scaleImage(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.base.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    /**
     获取圆形的图片
    */
    public func circleImage(_ radius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(self.base.size)
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius*2, height: radius*2))
        path.addClip()
        self.base.draw(in: CGRect(x: 0, y: 0, width: radius*2, height: radius*2))
        let cImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return cImage!
    }
}

extension Data {
    /**
     获取data size
     
     - returns: kb
     */
    func size() -> Int {
        let sizeOrigin = Int64(self.count)
        let sizeOriginKB = Int(sizeOrigin / 1024)
        return sizeOriginKB
    }
}

