//
//  YSKitTest.swift
//  Demo
//
//  Created by liukai on 2017/10/1.
//  Copyright © 2017年 尧尚信息科技. All rights reserved.
//

import Foundation
import YsSwift

class YSKitTest {
    func testString() {
        let s = "         hello world      "
        // Do any additional setup after loading the view, typically from a nib.
        print("\(s.ys.trim())")
        var d = "0.11"
        print("\(d.ys.double())")
        d = "abc"
        print("\(d.ys.double())")
    }
}
