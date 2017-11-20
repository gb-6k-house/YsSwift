/******************************************************************************
 ** auth: liukai
 ** date: 2017/8
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import UIKit

import UIKit


public struct YSLineSeparatorOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let top = YSLineSeparatorOptions(rawValue: 1)
    public static let bottom = YSLineSeparatorOptions(rawValue: 2)
    public static let left = YSLineSeparatorOptions(rawValue: 4)
    public static let right = YSLineSeparatorOptions(rawValue: 8)
}


open class YSLineSeparatorCollectionViewCell: YSCollectionViewCell {
    
    public var linwSeparatorOptions: YSLineSeparatorOptions = [.top, .bottom, .left, .right] {
        didSet {
            if let sublayers = contentView.layer.sublayers {
                
                _ = sublayers.map {
                    if $0.isMember(of:CAShapeLayer.self) {
                        $0.removeFromSuperlayer()
                    }
                }
            }
            setNeedsDisplay()
        }
    }
    
    public var lineColor = UIColor.init(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 0.7)
    public var lineWidth: CGFloat = 1
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if linwSeparatorOptions.contains(.top) {
            let layer = CAShapeLayer()
            layer.lineWidth = self.lineWidth
            //            layer.borderWidth = 1
            layer.strokeColor = lineColor.cgColor
            
            let path = UIBezierPath.init()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.size.width, y: 0))
            
            layer.path = path.cgPath
            contentView.layer.addSublayer(layer)
        }
        
        if linwSeparatorOptions.contains(.bottom) {
            let layer = CAShapeLayer()
            layer.lineWidth = self.lineWidth
            //            layer.borderWidth = 1
            layer.strokeColor = lineColor.cgColor
            
            let path = UIBezierPath.init()
            path.move(to: CGPoint(x: 0, y: rect.size.height-self.lineWidth))
            path.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height-self.lineWidth))
            
            layer.path = path.cgPath
            contentView.layer.addSublayer(layer)
        }
        
        if linwSeparatorOptions.contains(.left) {
            let layer = CAShapeLayer()
            layer.lineWidth = self.lineWidth
            //            layer.borderWidth = 1
            layer.strokeColor = lineColor.cgColor
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.size.height))
            
            layer.path = path.cgPath
            contentView.layer.addSublayer(layer)
        }
        
        if linwSeparatorOptions.contains(.right) {
            let layer = CAShapeLayer()
            layer.lineWidth = 1
            //            layer.borderWidth = 1
            layer.strokeColor = lineColor.cgColor
            
            let path = UIBezierPath.init()
            path.move(to: CGPoint(x: rect.size.width-self.lineWidth, y: 0))
            path.addLine(to: CGPoint(x: rect.size.width-self.lineWidth, y: rect.size.height))
            
            layer.path = path.cgPath
            contentView.layer.addSublayer(layer)
        }
    }
}

