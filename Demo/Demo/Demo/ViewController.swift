//
//  ViewController.swift
//  Demo
//
//  Created by niupark on 2017/9/30.
//  Copyright © 2017年 尧尚信息科技. All rights reserved.
//

import UIKit
import YSKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let s = "         hello world      "
        
        // Do any additional setup after loading the view, typically from a nib.
        print("\(s.ys.trim())")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

