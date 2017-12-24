/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import UIKit
import RxSwift
import FDFullscreenPopGesture


open class YSNavagtionConfig {
    public var showback = true
    public var backImage = YSBaseUIConfigs.navigationBackImageName
    public var backImageTintColor = YSBaseUIConfigs.navigationBackImageTintColor
    public var titleColor = YSBaseUIConfigs.navigationTitleColor
    public var titleFont = YSBaseUIConfigs.navigationTitleFont
    public var backgourdColor = YSBaseUIConfigs.navigationBackgroudColor
}


open class YSBaseViewController: UIViewController, UINavigationBarDelegate {
    
    class  _BaseUINavigationBar: UINavigationBar {
        override func layoutSubviews() {
            super.layoutSubviews()
            //
            if #available(iOS 11, *) {
                for view in self.subviews {
                    if view.className().contains("Background"){
                        view.frame = self.bounds
                    }else if view.className().contains("ContentView") {
                        var frame = view.frame
                        frame.origin.y = 20
                        frame.size.height = self.bounds.size.height - frame.origin.y
                        view.frame = frame
                    }
                }
            }
        }

    }
    
    public var showCustomNavigationBar: Bool = false {
        didSet {
            self.fd_prefersNavigationBarHidden = showCustomNavigationBar
            
        }
    }
    
    public var customTitleItem: UINavigationItem?
    
    public var customNavigationBar: UINavigationBar?
    
    public  convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = true
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.edgesForExtendedLayout = []
        
        self.buildVariable()
        self.buildVM()
        self.buildUI()
        self.buildRx()
        
    }
    
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("\(self) deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    open func customNavigationConfig(_ config: YSNavagtionConfig) {
        
    }
    
    open func setup() {
        self.hidesBottomBarWhenPushed = true
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    
    
    override open var prefersStatusBarHidden: Bool {
        return false
    }
    
    //界面被push到导航栏之前，调用的方法。withddata一般是前一个页面传递数据
    
    open func beforePush(_ withdata:Any?){
        
    }
    //后一个页面被pop之前，会调用前一个页面的beforePopNext，一般用于后一个页面向前一个页面传递数据
    
    open func beforePopNext(_ withdata:Any?){
        
    }
    // build variable
    open func buildVariable() {
        
    }
    
    // build view model
    open func buildVM() {
        
    }
    
    // build interface
    open func buildUI() {
        //配置背景色
        self.view.ys.customize { (view) in
            
            view.ys.handleTheme {
                view.backgroundColor = YSBaseUIConfigs.viewcontrollerbackGroundColor
            }
        }
        

        if let nav =  self.navigationController {
            if nav.viewControllers.count > 1 {
                let backButton: UIButton = UIButton().ys.customize { (view) in
                    
                    view.setImage(UIImage(named: YSBaseUIConfigs.navigationBackImageName)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
                    
                    view.frame = YSBaseUIConfigs.navigationBackImageRect
                    view.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
                    view.imageEdgeInsets = UIEdgeInsets.zero
                    view.addTarget(self, action: #selector(actionBack), for: .touchUpInside)
                    view.setTitleColor(YSBaseUIConfigs.navigationTitleColor, for: .normal)
                    view.imageView?.tintColor = YSBaseUIConfigs.navigationBackImageTintColor
                    
                }
                self.navigationItem.leftBarButtonItems = [UI.barFixedSpace, UIBarButtonItem(customView: backButton)]
                
                
            }
            
            nav.navigationBar.ys.handleTheme {[unowned nav] in
                nav.navigationBar.ys.customize({ (view) in
                    view.setBackgroundImage(UIImage.colorImage( YSBaseUIConfigs.navigationBackgroudColor, size: CGSize(width: UIScreen.main.bounds.width, height: 64)), for: .default)
                    view.titleTextAttributes = [
                        NSAttributedStringKey.foregroundColor: YSBaseUIConfigs.navigationTitleColor,
                        NSAttributedStringKey.font: YSBaseUIConfigs.navigationTitleFont
                    ]
                    view.shadowImage = UIImage()
                })
            }
            
        }
        
        
        
        if self.showCustomNavigationBar {
            
            let config = YSNavagtionConfig()
            self.customNavigationConfig(config)
            
            self.customNavigationBar = _BaseUINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64)).ys.customize { (view) in
                
                self.customTitleItem = UINavigationItem(title: self.title ?? " ").ys.customize({ (view) in
                    if config.showback {
                        let backButton: UIButton = UIButton().ys.customize { (view) in
                            if let image = UIImage(named: config.backImage){
                                view.setImage(image.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
                                
                                view.frame =  CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height) //  YSBaseUIConfigs.navigationBackImageRect
 
                            }
                            view.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
                            view.imageEdgeInsets = UIEdgeInsets.zero
                            view.addTarget(self, action: #selector(actionBack), for: .touchUpInside)
                            view.setTitleColor(config.titleColor, for: .normal)
                            view.imageView?.tintColor = config.backImageTintColor
                            
                            
                        }
                        view.leftBarButtonItems = [UI.barFixedSpace, UIBarButtonItem(customView: backButton)]
                        
                    }
                    
                })
                
                view.setItems([self.customTitleItem!], animated: false)
                view.delegate = self
                view.ys.handleTheme { [weak view] in
                    guard let `view` = view else{
                        return
                    }
                    view.setBackgroundImage(UIImage.colorImage(config.backgourdColor, size: CGSize(width: UIScreen.main.bounds.width, height: 64)), for: .default)
                    view.shadowImage = UIImage()
                    view.titleTextAttributes = [
                        NSAttributedStringKey.foregroundColor: config.titleColor,
                        NSAttributedStringKey.font: config.titleFont
                    ]
                    view.tintColor = YSBaseUIConfigs.navigationBackgroudColor
                }
                self.view.addSubview(view)
            }
            
            _ = self.rx.observe(String.self, "title", options: [.new, .initial], retainSelf: false)
                .takeUntil(self.rx.deallocated)
                .subscribe(onNext: { [weak self](title) in
                    
                    if let `self` = self,  let titleItem = self.customTitleItem {
                        titleItem.title = title
                    }
                })
            
        }
        
        
    }
    
    @objc open func actionBack() {
        guard let nav = self.navigationController, nav.viewControllers.count > 1 else {
            self.ys.dismiss()
            return
        }
        
        self.ys.pop()
    }
    
    // build rxswift bind
    open func buildRx() {
        
        
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.showCustomNavigationBar {
            self.customNavigationBar?.superview?.bringSubview(toFront: self.customNavigationBar!)
        }
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        
        guard let nav = self.navigationController, nav.viewControllers.count > 1 else {
            self.ys.dismiss()
            return false
        }
        
        self.ys.pop()
        return true
    }
    
}

