/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/


import Foundation
import RxSwift
import ObjectiveC

public func == < E: YSEnumable> (lhs: E, rhs: E) -> Bool where E.RawValue == Int {
    return lhs.rawValue == rhs.rawValue
}

public protocol SettingAsyc {
    // 同步到服务器的值
    var value: AnyObject { get }
    // 同步到服务器的键
    static var key: String { get }
}

public protocol YSEnumable: RawRepresentable, Equatable, Hashable, SettingAsyc {

    var i18n: String { get }
    var icon: UIImage? { get }
    static var defaultValue: Self { get }
    static var allValues: [Self] { get }
    static var title: String { get }

    // static var normalValue: Self { get }
}

public extension YSEnumable where RawValue == Int {
    var hashValue: Int {
        return self.rawValue.hashValue
    }
}

/**
 配置Cell的事件类型

 - Single:  单选
 - Mutiple: 多选
 - Switch:  开关
 - Next:    下一级页面
 - Tap:     点击
 - button:   按钮
 - text:    编辑框
 - None:    其他
 */
public enum ConfigSelectedMode {
    case single
    case mutiple
    case `switch`
    case next
    case tap
    case button
    case text
    case none
}

public typealias ConfigValue = (String, ConfigSelectedMode, UIImage?)

public extension Array where Element: YSBaseOptionConfig {

   public  var sectionName: String {
        get {
            return self.first?.sectionName ?? ""
        }
        set {
            self.first?.sectionName = newValue
        }
    }

   public var minCount: Int {
        get {
            return self.first?.sectionMinCount ?? 0
        }
        set {
            self.first?.sectionMinCount = newValue
        }
    }
}

public protocol OptionConfigController {

    init(config: YSBaseOptionConfig)

}

/// 可选配置基础类
open class YSBaseOptionConfig: NSObject {

    open var i18n = ""
    open var icon: Variable<UIImage?> = Variable(nil)
    open var selectedMode: ConfigSelectedMode = .none
    open var nextConfigs: [[YSBaseOptionConfig]] = []

    /// 通知名称
    open var notificationName: Notification.Name?
    /// 子标题
    open var subTitle: Variable<String> = Variable("")

    /// 上一级配置
    open weak var parentConfig: YSBaseOptionConfig?

    open var nextController: AnyClass?
    open var needPresent: Bool = false

    // Section相关属性
    open var sectionName: String = ""
    open var sectionMinCount: Int?
    open var rowHeight: CGFloat?

    //ConfigSelectedMode.text模式下的text
    open var text: String?
    /**
     读写键

     需要存储的时候设定唯一字符串, 命名规范为：
     ..superClassName.className.propertyName
     */
    var readWriteKey = ""

    /// 是否已被选取
    var selected = false

    /// 上传事件处理
    var uploadHandler: (() -> Void)?

    open var selectedEvent = PublishSubject<YSBaseOptionConfig>()

    public convenience  init(title: String, select: ConfigSelectedMode, icon: UIImage?) {
        let value = (title, select, icon)
        self.init(value: value)
    }

    public init(value: ConfigValue) {
        self.i18n = value.0
        self.selectedMode = value.1
        self.icon.value = value.2
    }

    public convenience override init() {
        self.init(value: ("", .single, nil))
    }

    final public func setupNextConfigs(_ configs: [[YSBaseOptionConfig]]) {
        //
        self.nextConfigs = configs

        for cs in configs {
            for c in cs {
                c.parentConfig = self
            }
        }
    }

    public final func didSelected() {
        selectedEvent.onNext(self)
    }
    
}

// MARK: - 单选列表的上一级数据
/**
 单选列表的上一级数据

 如 "主题" 数据，管理黑色亮色...

 不同列表必须用不同的 E 类型
 */
open class YSAppConfigSingle < E: YSEnumable>: YSBaseOptionConfig where E.RawValue == Int {

    open var value: E = E.defaultValue {
        didSet {
            self.subTitle.value = value.i18n
//            if currentSelect == nil {
//                currentSelect = config(value)
//                currentSelect.selected = true
//            }
        }
    }
    var currentSelect: YSBaseOptionConfig!

   public  init(none: Int?) {
        super.init(value: ("", .next, nil))
    }

    public convenience  init() {
        self.init(none: nil)
        self.i18n = E.title
        self.selectedMode = .next

        self.readWriteKey = self.ys.className()
        self.loadValue()

        self.setupNextConfigs([self.valuesToConfigs()])
    }

    func valuesToConfigs() -> [YSBaseOptionConfig] {
        var configs: [YSBaseOptionConfig] = []
        for (idx, v) in E.allValues.enumerated() {
            let c = YSBaseOptionConfig()
            c.i18n = v.i18n
            c.icon.value = v.icon
            c.selectedMode = .single
            // 是否已被选取
            if E.allValues[idx] == self.value {
                c.selected = true
                self.currentSelect = c
            }
//            else if self.currentSelect == nil {
//                self.currentSelect = config(E.normalValue)
//                self.currentSelect.selected = true
//            }

            // 选取绑定
            _ = c.selectedEvent.takeUntil(self.rx.deallocated).subscribe(onNext: { [unowned self](config) in
                // self.value = config
                guard let idx = self.nextConfigs.first?.index(of: config) else { return }
                if self.currentSelect != nil {
                    self.currentSelect.selected = false
                }
                config.selected = true
                self.currentSelect = config
                self.value = E.allValues[idx]
                self.saveValue()
            })

            configs.append(c)
        }
        return configs
    }

    fileprivate func config(_ value: E) -> YSBaseOptionConfig {
        let c = YSBaseOptionConfig()
        c.i18n = value.i18n
        c.icon.value = value.icon
        c.selectedMode = .single
        return c
    }

   open func saveValue() {

//        let info = UserDefaults.standard
//        info.setInteger(self.value.rawValue, forKey: self.readWriteKey)
        Defaults[DefaultsKey<Int?>(self.readWriteKey)] = self.value.rawValue
//        info.synchronize()

        uploadHandler?()

        if let noti = self.notificationName {
            debugPrint("发送通知 － \(noti)")
            NotificationCenter.default.post(name: noti, object: nil)
        }

    }

    open func loadValue() {

        if E.allValues.count == 1 {
            self.value = E.defaultValue
            return
        }

        guard let rawValue = Defaults[DefaultsKey<Int?>(self.readWriteKey)] else {
            self.value = E.defaultValue
            return
        }

        // let info = UserDefaults.standard
        if let v = E(rawValue: rawValue) {
            if E.allValues.contains(v) {
                self.value = v
            } else {
                self.value = E.defaultValue
            }
        } else {
            self.value = E.defaultValue
        }
    }
}

// MARK: - 多选列表的上一级数据
/**
 多选列表的上一级数据

 如 "主题" 数据，管理黑色亮色...

 不同列表必须用不同的 E 类型
 */
open class YSAppConfigMutiple < E: YSEnumable>: YSBaseOptionConfig where E.RawValue == Int {

    var value: Set<E> = []
    var currentSelect: Set<YSBaseOptionConfig> = []

    init(none: Int?) {
        super.init(value: ("", .mutiple, nil))
    }

    convenience init() {
        self.init(none: nil)
        self.i18n = E.title
        self.selectedMode = .next

        self.readWriteKey = self.ys.className()
        self.loadValues()

        self.setupNextConfigs([self.valuesToConfigs()])
    }

    func valuesToConfigs() -> [YSBaseOptionConfig] {
        var configs: [YSBaseOptionConfig] = []
        for v in E.allValues {
            let c = YSBaseOptionConfig()
            c.i18n = v.i18n
            c.icon.value = v.icon
            c.selectedMode = .single
            // 是否已被选取
            if self.value.contains(v) {
                c.selected = true
            }
            // 选取绑定
            _ = c.selectedEvent.takeUntil(self.rx.deallocated).subscribe(onNext: { [unowned self](config) in
                // self.value = config
                config.selected = !config.selected
                if config.selected {
                    self.currentSelect.insert(config)
                } else {
                    self.currentSelect.remove(config)
                }
            })

            configs.append(c)
        }
        return configs
    }

    func saveValues() {

        uploadHandler?()
        let info = UserDefaults.standard
        let vs = self.value.map({ $0.rawValue })
        info.set(vs, forKey: self.readWriteKey)
        info.synchronize()

    }

    func loadValues() {
        let info = UserDefaults.standard
        guard let values = info.object(forKey: self.readWriteKey) as? [Int], values.count > 0 else {
            return
        }

        self.value = []
        for v in values {
            if let e = E(rawValue: v) {
                self.value.insert(e)
            }
        }
    }

}

// MARK: - 开关选项数据
/**
 开关选项数据
 */
class YSAppConfigSwitch: YSBaseOptionConfig {

    var value: Bool {
        didSet {
            self.switchEvent.onNext(value)
        }
    }
    var key: String

    /// 类似通知，密码锁
    var needCloseOtherCells = false

    override var selected: Bool {
        didSet {
            if value != selected {
                self.value = selected
                self.saveValue()
                if let noti = self.notificationName {
                    debugPrint("发送通知 － \(noti)")
                    NotificationCenter.default.post(name: noti, object: nil)
                }
            }
        }
    }

    var switchEvent = PublishSubject<Bool>()

    /**
     必须以此初始化开关选项

     - parameter key: 存取数据Key 必须唯一
     - parameter value: 默认值
     */
    init(key: String, value: Bool) {
        self.key = key
        self.value = value
        super.init(value: ("", .switch, nil))

        self.readWriteKey = key
        self.loadValue()
    }

    func saveValue() {
        uploadHandler?()
        Defaults[DefaultsKey<Bool?>(self.readWriteKey)] = self.selected

    }

    func loadValue() {

        if let value = Defaults[DefaultsKey<Bool?>(self.readWriteKey)] {
            self.value = value
            self.selected = value
        } else {
            self.value = false
            self.selected = false
        }

    }
}

// MARK: - 其他类型选值 Element必须遵循NSCoding
class YSOtherValueOptionConfig<Element>: YSBaseOptionConfig {

    var value: Variable<Element?> = Variable(nil) {
        didSet {
            self.buildRx()
        }
    }

    // subTitle 格式化处理 比如 出生年份 -> 年龄
    var titleFormatHandler: ((_ value: Element) -> String)?

    var bag: DisposeBag?

    init(keyValue: String, handler: ((_ value: Element) -> String)? = nil) {
        super.init(value: ("", .none, nil))

        // assert(Element.self is NSCoding, "OtherValueOptionConfig泛型的Element必须遵循NSCoding")

        self.titleFormatHandler = handler

        self.buildRx()
        self.readWriteKey = keyValue
        self.loadValue()
//        if let v = self.value.value as? Int where v == 2010 {
//            debugPrint("\(self.subTitle.value)")
//        }
    }

    func buildRx() {

        self.bag = DisposeBag()

        value.asObservable().subscribe(onNext: { [unowned self](element) in
            guard let v = element else {
                self.subTitle.value = ""
                return
            }
            self.saveValue()

            if let format = self.titleFormatHandler {
                self.subTitle.value = format(v)
            } else {
                self.subTitle.value = "\(v)"
            }
        }).disposed(by: self.bag!)
    }

    func saveValue() {
        uploadHandler?()
        let info = UserDefaults.standard
        if let object = self.value.value, object is NSCoding {
            let archivedObject = NSKeyedArchiver.archivedData(withRootObject: object)
            info.set(archivedObject, forKey: self.readWriteKey)
        }
        info.synchronize()
    }

    func loadValue() {
        let info = UserDefaults.standard
        if let oldValue = info.object(forKey: self.readWriteKey) as? Element {
            self.value.value = oldValue
            debugPrint("\(self.subTitle.value)")
        } else if let archivedObject = info.object(forKey: self.readWriteKey) as? Data {
            if let v = NSKeyedUnarchiver.unarchiveObject(with: archivedObject) as? Element {
                self.value.value = v
            }
        }
    }
}
