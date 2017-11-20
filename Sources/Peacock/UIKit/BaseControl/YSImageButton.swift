/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import UIKit

public enum YSImagePosition {
    case top
    case left
    case bottom
    case right

    case topEdge
    case leftEdge
    case bottomEdge
    case rightEdge

    case none
}

open class YSImageButton: UIButton {

    var spacing: CGFloat
    var position: YSImagePosition

    public init(position: YSImagePosition, spacing: CGFloat) {

        self.position = position
        self.spacing = spacing

        super.init(frame: CGRect.zero)
    }

    required public init?(coder aDecoder: NSCoder) {

        self.position = .left
        self.spacing = 0.0

        super.init(coder: aDecoder)

    }

    override open func layoutSubviews() {

        super.layoutSubviews()

        let labelSize = self.titleLabel!.frame.size
        let imageSize = self.imageView!.frame.size

        let totalWidth = labelSize.width + imageSize.width + spacing
        let totalHeight = labelSize.height + imageSize.height + spacing

        var imageFrame = CGRect.zero
        var labelFrame = CGRect.zero

        switch self.position {
        case .left:
            imageFrame = CGRect(x: self.bounds.width / 2.0 - totalWidth / 2.0, y: self.bounds.height / 2.0 - imageSize.height / 2.0, width: imageSize.width, height: imageSize.height)
            labelFrame = CGRect(x: imageFrame.maxX + spacing, y: self.bounds.height / 2.0 - labelSize.height / 2.0, width: labelSize.width, height: labelSize.height)

        case .right:
            labelFrame = CGRect(x: self.bounds.width / 2.0 - totalWidth / 2.0, y: self.bounds.height / 2.0 - labelSize.height / 2.0, width: labelSize.width, height: labelSize.height)
            imageFrame = CGRect(x: labelFrame.maxX + spacing, y: self.bounds.height / 2.0 - imageSize.height / 2.0, width: imageSize.width, height: imageSize.height)
        case .top:
            imageFrame = CGRect(x: self.bounds.width / 2.0 - imageSize.width / 2.0, y: self.bounds.height / 2.0 - totalHeight / 2.0, width: imageSize.width, height: imageSize.height)
            labelFrame = CGRect(x: 5, y: imageFrame.maxY + spacing, width: self.bounds.width - 10, height: labelSize.height)
        case .bottom:
            labelFrame = CGRect(x: 5, y: self.bounds.height / 2.0 - totalHeight / 2.0, width: self.bounds.width - 10, height: labelSize.height)
            imageFrame = CGRect(x: self.bounds.width / 2.0 - imageSize.width / 2.0, y: labelFrame.maxY + spacing, width: imageSize.width, height: imageSize.height)

        case .leftEdge:
            imageFrame = CGRect(x: 0, y: self.bounds.height / 2.0 - imageSize.height / 2.0, width: imageSize.width, height: imageSize.height)
            labelFrame = CGRect(x: imageSize.width + spacing, y: self.bounds.height / 2.0 - labelSize.height / 2.0, width: labelSize.width, height: labelSize.height)
        case .rightEdge:
            labelFrame = CGRect(x: 0, y: self.bounds.height / 2.0 - labelSize.height / 2.0, width: labelSize.width, height: labelSize.height)
            imageFrame = CGRect(x: self.bounds.width - imageSize.width - spacing, y: self.bounds.height / 2.0 - imageSize.height / 2.0, width: imageSize.width, height: imageSize.height)
        case .topEdge:
            imageFrame = CGRect(x: self.bounds.width / 2.0 - imageSize.width / 2.0, y: 0, width: imageSize.width, height: imageSize.height)
            labelFrame = CGRect(x: 5, y: imageSize.height + spacing, width: self.bounds.width - 10, height: labelSize.height)
        case .bottomEdge:
            labelFrame = CGRect(x: 5, y: self.bounds.height - imageSize.height - labelSize.height - spacing, width: self.bounds.width - 10, height: labelSize.height)
            imageFrame = CGRect(x: self.bounds.width / 2.0 - imageSize.width / 2.0, y: self.bounds.height - imageSize.height, width: imageSize.width, height: imageSize.height)

        default:
            break
        }

        self.titleLabel?.frame = labelFrame
        self.imageView?.frame = imageFrame
    }
}
