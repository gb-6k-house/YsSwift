/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import UIKit
//统一导出YSKit下界面的配置信息

open class YSUI: NSObject {
    
    public struct Apperance {
        //配置YSBaseViewController backgroudColor
        static  public var backgroudColor :UIColor {
            set {
                YSBaseUIConfigs.viewcontrollerbackGroundColor = newValue
            }
            get {
                return YSBaseUIConfigs.viewcontrollerbackGroundColor
            }
        }
        
        static public var navigationBackImageName: String {
            set {
                YSBaseUIConfigs.navigationBackImageName = newValue
            }
            get {
                return YSBaseUIConfigs.navigationBackImageName
            }
        }
        
        static public var navigationBackImageTintColor: UIColor {
            set {
                YSBaseUIConfigs.navigationBackImageTintColor = newValue
            }
            get {
                return YSBaseUIConfigs.navigationBackImageTintColor
            }
        }
        
        
        static public var navigationBackImageRect: CGRect {
            set {
                YSBaseUIConfigs.navigationBackImageRect = newValue
            }
            get {
                return YSBaseUIConfigs.navigationBackImageRect
            }
        }
        
        
        static public var navigationTitleColor: UIColor {
            set {
                YSBaseUIConfigs.navigationTitleColor = newValue
            }
            get {
                return YSBaseUIConfigs.navigationTitleColor
            }
        }
        
        static public var navigationTitleFont: UIFont {
            set {
                YSBaseUIConfigs.navigationTitleFont = newValue
            }
            get {
                return YSBaseUIConfigs.navigationTitleFont
            }
        }

        static public var navigationBackgroudColor: UIColor {
            set {
                YSBaseUIConfigs.navigationBackgroudColor = newValue
            }
            get {
                return YSBaseUIConfigs.navigationBackgroudColor
            }
        }
        //配置 tableviewcell   
        
        static public var tableViewCellLineColor: UIColor {
            set {
                YSBaseTableViewConfig.lineColor = newValue
            }
            get {
                return YSBaseTableViewConfig.lineColor
            }
        }
        
        static public var tableViewCellArrowImage: UIImage? {
            set {
                YSBaseTableViewConfig.arrowImage = newValue
            }
            get {
                return YSBaseTableViewConfig.arrowImage
            }
        }

        static public var tableViewCellBackgroudColor: UIColor {
            set {
                YSBaseTableViewConfig.backgroundColor = newValue
            }
            get {
                return YSBaseTableViewConfig.backgroundColor
            }
        }
        static public var tableViewCellTitleColor: UIColor {
            set {
                YSBaseTableViewConfig.textColor = newValue
            }
            get {
                return YSBaseTableViewConfig.textColor
            }
        }
        
        static public var tableViewCellSubTitleColor: UIColor {
            set {
                YSBaseTableViewConfig.detailColor = newValue
            }
            get {
                return YSBaseTableViewConfig.detailColor
            }
        }
        
        static public var tableViewCellTitleFont: UIFont {
            set {
                YSBaseTableViewConfig.textFont = newValue
            }
            get {
                return YSBaseTableViewConfig.textFont
            }
        }
        static public var tableViewCellSubTitleFont: UIFont {
            set {
                YSBaseTableViewConfig.detailFont = newValue
            }
            get {
                return YSBaseTableViewConfig.detailFont
            }
        }
        
        static public var appConfigSelectedImage: UIImage? {
            set {
                YSAppConfigControllerConfig.selectImage = newValue
            }
            get {
                return YSAppConfigControllerConfig.selectImage
            }
        }
        
        
        
    }
    static  public let UIManager = UI
}
