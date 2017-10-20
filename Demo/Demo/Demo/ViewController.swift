//
//  ViewController.swift
//  Demo
//
//  Created by liukai on 2017/9/30.
//  Copyright © 2017年 尧尚信息科技. All rights reserved.
//

import UIKit
import YsSwift
import Nuke
import  SDWebImage
class ViewController: UIViewController {

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

extension UIButton : YsSwift.Target {
    
    public func handle(response: YsSwift.Result<YsSwift.Image>, isFromMemoryCache: Bool) {
        guard let image = response.value else { return }
        self.setImage(image, for: .normal)
    }
}

