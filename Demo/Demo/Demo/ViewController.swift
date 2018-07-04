//
//  ViewController.swift
//  Demo
//
//  Created by liukai on 2017/9/30.
//  Copyright © 2017年 尧尚信息科技. All rights reserved.
//

import UIKit
import YsSwift
import SDWebImage
import Kingfisher

public extension YSSwift where Base: NSDate {
    public func weak(len: String = "en") -> String {
        let enWeak = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let zhWeak = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
        let calendar = NSCalendar.current
        let weakIndex = calendar.component(Calendar.Component.weekday, from: self.base as Date)-1
        if len == "zh_hans" {
            return zhWeak[weakIndex]
        }else {
            return enWeak[weakIndex]
        }
    }
}

class ViewController: YSBaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nukeImageView: UIImageView!
    @IBOutlet weak var sdImageView: UIImageView!
    let button = UIButton()
    var webFile: WebFile?
    override func viewDidLoad() {
        super.viewDidLoad()
        let ysKit = YSKitTest()
        //http://bmob-cdn-15714.b0.upaiyun.com/2018/03/14/5327e93efaf44364883e7eefd021efb5.zip
        ysKit.testString()
//        self.imageView.ys.loadImage(with: URL(string: "http://www.easyicon.net/api/resizeApi.php?id=1100251&size=128")!, placeholder: UIImage(named:"rabbit_1"))
        
        YsSwift.Manager.shared.defauleLoader.trustedHosts = ["iot.comba.com.cn"]
        
        self.imageView.ys.loadImage(with: URL(string: "https://iot.comba.com.cn:8443/load/excel/1514535279235.png")!, placeholder: UIImage(named:"rabbit_1"))

        
        let url = URL(string: "https://iot.comba.com.cn:8443/load/excel/1514535279235.png")
        self.nukeImageView.kf.setImage(with: url)
        
        self.sdImageView.sd_setImage(with:  URL(string: "https://iot.comba.com.cn:8443/load/excel/1514535279235.png"), placeholderImage: UIImage(named:"rabbit_1"), options: .allowInvalidSSLCertificates, completed: nil)
        
        self.sdImageView.sd_setImage(with:  URL(string: "https://iot.comba.com.cn:8443/load/excel/1514535279235.png"), placeholderImage: UIImage(named:"rabbit_1"), completed: nil)
        self.webFile = WebFile(with: Request(url: URL(string: "http://bmob-cdn-15714.b0.upaiyun.com/2018/03/14/5327e93efaf44364883e7eefd021efb5.zip")!))
        self.webFile?.download(completion: { (url) in
            print("下载完成")

        }) { (progress) in
            print("当前进度\(progress)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()     
        // Dispose of any resources that can be recreated.
    }

    @IBAction func refreshAction(_ sender: Any) {
        
        self.imageView.ys.loadImage(with: URL(string: "https://iot.comba.com.cn:8443/load/excel/1514535279235.png")!, placeholder: UIImage(named:"rabbit_1"))
     }
}


