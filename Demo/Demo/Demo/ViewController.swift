//
//  ViewController.swift
//  Demo
//
//  Created by liukai on 2017/9/30.
//  Copyright © 2017年 尧尚信息科技. All rights reserved.
//

import UIKit
import YsSwift

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
    override func viewDidLoad() {
        super.viewDidLoad()
        let ysKit = YSKitTest()
        ysKit.testString()
        self.imageView.ys.loadImage(with: URL(string: "http://www.easyicon.net/api/resizeApi.php?id=1100251&size=128")!, placeholder: UIImage(named:"rabbit_1"))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()     
        // Dispose of any resources that can be recreated.
    }

    @IBAction func refreshAction(_ sender: Any) {
        
        self.imageView.ys.loadImage(with: URL(string: "http://www.easyicon.net/api/resizeApi.php?id=1100251&size=128")!)
     }
}


