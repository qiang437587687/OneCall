//
//  Tools.swift
//  OneCallEx
//
//  Created by zhangxianqiang on 2018/3/3.
//  Copyright © 2018年 XQ. All rights reserved.
//

import Foundation
import PushKit


@discardableResult
func getMeaningToken(credentials: PKPushCredentials) -> String {
    var token = ""
    for i in 0..<credentials.token.count {
        token = token + String(format: "%02.2hhx", arguments: [credentials.token[i]])
    }
    return token
}

func currentTopVc() -> UIViewController {
    let keywindow = UIApplication.shared.keyWindow
    let firstView: UIView = (keywindow?.subviews.first)!
    let secondView: UIView = firstView.subviews.first!
    let vc = viewForController(view: secondView)
    
    if vc == nil {print("获取currentvc失败")}
    
    return vc ?? UIViewController()
}

func viewForController(view:UIView)->UIViewController?{
    var next:UIView? = view
    repeat{
        if let nextResponder = next?.next, nextResponder is UIViewController {
            return (nextResponder as! UIViewController)
        }
        next = next?.superview
    }while next != nil
    return nil
}


func tempShowTip(_ message:String? = "系统提示") {
    let alertController = UIAlertController(title: message,
                                            message: "这是个提示消息", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
    let okAction = UIAlertAction(title: "好的", style: .default, handler: {action in
        print("点击了确定")
    })
    alertController.addAction(cancelAction)
    alertController.addAction(okAction)
    currentTopVc().present(alertController, animated: true, completion: nil)
}

