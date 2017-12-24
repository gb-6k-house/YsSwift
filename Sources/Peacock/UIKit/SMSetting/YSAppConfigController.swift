/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import UIKit
import RxSwift
import IQKeyboardManagerSwift

/// 所有设置逻辑的控制器
open class YSAppConfigController: YSTableViewController, OptionConfigController {

    open var config: YSBaseOptionConfig?
    private let confirmButton = UIButton()
    // 需要重新reload的cell -1为不刷新
    var reloadIndexPath: IndexPath?

    // 是否展开全部cell
//    var expendCells = true

    required convenience public init(config: YSBaseOptionConfig) {
        self.init()
        self.config = config
    }

//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        if let indexPath = self.reloadIndexPath {
//            self.tableView.reloadRow(UInt(indexPath.row), inSection: UInt(indexPath.section), withRowAnimation: .Fade)
//            self.reloadIndexPath = nil
//        }
//    }

    override open func setup() {
        super.setup()

        self.tableViewStyle = .grouped
    }

    override open func buildUI() {
        super.buildUI()

        if config?.selectedMode == .mutiple {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.confirmButton)
        }

        self.tableView.cellLayoutMarginsFollowReadableWidth = false

        self.tableView.ys.register(YSAppConfigBaseCell.self)
        self.tableView.ys.register(YSAppConfigSelectedCell.self)
        self.tableView.ys.register(YSAppConfigSwitchCell.self)
        self.tableView.ys.register(YSAppConfigButtonCell.self)
        self.tableView.ys.register(YSAppConfigTextCell.self)

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override open func buildRx() {
        super.buildRx()

        self.ys.handleI18n { [unowned self] in
            self.title = I18n(self.config?.i18n)
            // USRegionViewModel.focusRegions.value = Defaults[kUserRegions] as! [Data]

            self.tableView.reloadData()
        }
    }

    // MARK: - UITableView
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return config?.nextConfigs.count ?? 0
    }

   open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let title = config?.nextConfigs[section].sectionName, title.characters.count > 0 {
            return 36
        }

        return 10
    }

    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let title = config?.nextConfigs[section].sectionName, title.characters.count > 0 {
            return I18n(title)
        }
        return nil
    }

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return config?.nextConfigs[indexPath.section][indexPath.row].rowHeight ?? YSAppConfigControllerConfig.rowHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return config?.nextConfigs[section].count ?? 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, config: YSBaseOptionConfig?) -> UITableViewCell {
        
        guard let item = config else {
            return UITableViewCell()
        }

        if item.selectedMode == .switch {
            let cell = tableView.dequeueReusableCell(withIdentifier: YSAppConfigSwitchCell.className()) as! YSAppConfigSwitchCell
            cell.updateUI(item)
            return cell
        } else if item.selectedMode == .mutiple || item.selectedMode == .single {
            let cell = tableView.dequeueReusableCell(withIdentifier: YSAppConfigSelectedCell.className()) as! YSAppConfigSelectedCell
            cell.updateUI(item)
            return cell
        } else if item.selectedMode == .button {
            let cell = tableView.dequeueReusableCell(withIdentifier: YSAppConfigButtonCell.className()) as! YSAppConfigButtonCell
            cell.updateUI(item)
            return cell
        } else if item.selectedMode == .text {
            let cell = tableView.dequeueReusableCell(withIdentifier: YSAppConfigTextCell.className()) as! YSAppConfigTextCell
            cell.updateUI(item)
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: YSAppConfigBaseCell.className()) as! YSAppConfigBaseCell
            cell.updateUI(item)
            
            return cell
            
        }
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       return self.tableView(tableView, cellForRowAt: indexPath, config: config?.nextConfigs[indexPath.section][indexPath.row])


    }

    @objc(tableView:willDisplayCell:forRowAtIndexPath:)
   open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {

        guard let cell = cell as? YSBaseTableViewCell else { return }

//        let rowNum = tableView.numberOfRows(inSection: indexPath.section)

        cell.showBottomLine = false
        switch indexPath.row {
        case 0:
            cell.showTopLine = false
//        case rowNum - 1:
//            cell.showTopLine = true
//            cell.topLineInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        default:
            cell.showTopLine = true
            cell.topLineInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }
    }

    open func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {

        guard let item = config?.nextConfigs[indexPath.section][indexPath.row] else {
            return
        }

        /**
         *  指向下一级页面，可能有非此模版的视图
         *
         */
        if item.selectedMode == .next {
            self.reloadIndexPath = indexPath

            // 遵循OptionConfigController协议的控件
            if let type = item.nextController as? OptionConfigController.Type {
                let controller = type.init(config: item)
                if let vc = controller as? UIViewController {
                    vc.title = I18n(item.i18n)

                    self.jumpToNextController(item, controller: vc)
                    return
                }
            }

            if item.nextConfigs.count > 0 {
                // 下一级

                if let type = item.nextController as? YSAppConfigController.Type {
                    // 是否有子类定制
                    let controller = type.init(config: item)
                    controller.title = I18n(item.i18n)

                    self.jumpToNextController(item, controller: controller)
                } else {
                    let controller = YSAppConfigController(config: item)

                    self.jumpToNextController(item, controller: controller)
                }
            } else {
                // 其他控件
                if let type = item.nextController as? UIViewController.Type {

                    let controller = type.init()
                    controller.title = I18n(item.i18n)
                    self.jumpToNextController(item, controller: controller)
                }
            }

        } else if item.selectedMode == .single {
            item.didSelected()
            self.ys.pop()
        } else if item.selectedMode == .tap || item.selectedMode == .button {

            if let noti = item.notificationName {
                NotificationCenter.default.post(name: noti, object: nil)
            }
        }
    }

    func jumpToNextController(_ item: YSBaseOptionConfig, controller: UIViewController) {
        //
        if item.needPresent {

            self.ys.present(controller)
        } else {
            self.ys.push(controller)
        }
    }
}

import SnapKit
import RxSwift
import RxCocoa

// MARK: - YSAppConfigBaseCell
open class YSAppConfigBaseCell: YSValue1Cell {

    weak var config: YSBaseOptionConfig?
    
    open override func setup() {
        super.setup()
        self.accessoryType = .none
    }

    open func updateUI(_ config: YSBaseOptionConfig) {
        //
        self.config = config
        if config.selectedMode == .next {
            self.accessoryType = .disclosureIndicator
        }
        _ = config.icon.asObservable().takeUntil(self.rx.deallocated).subscribe(onNext: { [unowned self](icon) in
            if let _icon = icon {
                self.imageView?.image = _icon
            
            } else {
                self.imageView?.image = nil
            }
        })

        
        self.textLabel?.text = I18n(config.i18n)
        _ = config.subTitle.asObservable().takeUntil(self.rx.deallocated).subscribe(onNext: { [unowned self](subTitle) in
            self.detailTextLabel?.text = I18n(subTitle)
        })

    }
}

class YSAppConfigButtonCell: YSValue1Cell {
    var titleLabel: UILabel!
    weak var config: YSBaseOptionConfig?

    override func setup() {
        super.setup()
        self.accessoryType = .none

        self.titleLabel = UILabel().ys.customize({ (view) in
            self.addSubview(view)
            view.font = Confige.textFont
            
            view.ys.handleTheme { [unowned view] in
                view.textColor = Confige.textColor
            }

            view.snp.makeConstraints({ (make) in
                make.center.equalTo(self)
            })
        })
    }
    
    func updateUI(_ config: YSBaseOptionConfig) {
        //
        self.config = config
        self.titleLabel?.text = I18n(config.i18n)
    }

}

class YSAppConfigTextCell: YSValue1Cell, UITextFieldDelegate {
    var textField: UITextField!
    weak var config: YSBaseOptionConfig?
    
    override func setup() {
        super.setup()
        self.accessoryType = .none
        
        self.textField = UITextField().ys.customize({ (view) in
            self.contentView.addSubview(view)
            view.font = Confige.textFont
            view.returnKeyType = .done
            view.delegate = self
            view.clearButtonMode = .whileEditing
            view.ys.handleTheme { [unowned view] in
                view.textColor = Confige.textColor
            }
            view.addDoneOnKeyboardWithTarget(self, action: #selector(self.done))
            view.snp.makeConstraints({ (make) in
                make.center.equalTo(self.contentView)
                make.height.equalTo(self.contentView)
                make.leading.equalTo(self.contentView).offset(10)
                make.trailing.equalTo(self.contentView).offset(-10)

            })
        })
    }
    @objc public func done() {
        config?.text = self.textField.text
        config?.didSelected()
        self.ys.viewController?.ys.pop()

    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.done()
        return true
    }
    
    func updateUI(_ config: YSBaseOptionConfig) {
        //
        self.config = config
        self.textField.placeholder = I18n(config.i18n)
        self.textField.text = config.text
        self.textField.becomeFirstResponder()
    }
    
}



// MARK: - YSAppConfigSelectedCell
class YSAppConfigSelectedCell: YSAppConfigBaseCell {

    var selectImage: UIImageView!

    override func setup() {
        super.setup()

        self.accessoryType = .none

        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.ys.handleTheme { [unowned view] in
            view.image = YSAppConfigControllerConfig.selectImage
        }

        self.selectImage = view

        self.accessoryView = self.selectImage
    }

    override func updateUI(_ config: YSBaseOptionConfig) {
        super.updateUI(config)

        _ = self.config!
            .rx.observe(Bool.self, "selected")
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [unowned self](select) in
                if select ?? false {
                    self.selectImage.isHidden = false
                } else {
                    self.selectImage.isHidden = true
                }
        })
    }
}

// MARK: - YSAppConfigSwitchCell
class YSAppConfigSwitchCell: YSAppConfigBaseCell {
    //
    var switchButton = UISwitch()

    override func setup() {
        super.setup()

        self.switchButton.onTintColor = YSAppConfigControllerConfig.switchTintColor
        self.accessoryView = self.switchButton
    }

    override func updateUI(_ config: YSBaseOptionConfig) {
        super.updateUI(config)

        self.switchButton.setOn(config.selected, animated: false)
        _ = self.switchButton.rx.value.takeUntil(self.rx.deallocated).subscribe(onNext: { [unowned self](on) in
            self.config!.selected = on
        })
    }
}

struct YSAppConfigControllerConfig {
    
    static var switchTintColor = UIColor.green //
    static var selectImage:UIImage? = UIImage()//选择的
    static var rowHeight:CGFloat = 50.0
}


