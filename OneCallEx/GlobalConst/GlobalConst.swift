//
//  GlobalConst.swift
//  OneCallEx
//
//  Created by zhangxianqiang on 2018/3/5.
//  Copyright © 2018年 XQ. All rights reserved.
//

import UIKit

// const string
let myConstCallString = "myConstCallString"
let otherConstCallString = "otherConstCallString"

// globle clousre
typealias SimpleClosure = () -> ()
typealias SimpleBoolClosure = (Bool) -> ()
typealias SimpleIntClosure = (Int) -> ()
typealias SimpleStringClosure = (String) -> ()
typealias SimpleImageClosure = (UIImage) -> ()

//全局方法
func confirmString(str:String?) -> Bool {
    if str == "" {return false}
    if str == nil { return false}
    if str == "NULL" {return false}
    if str?.count == 0 { return false}
    return true
}

