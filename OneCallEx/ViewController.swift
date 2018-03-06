//
//  ViewController.swift
//  OneCallEx
//
//  Created by zhangxianqiang on 2018/2/24.
//  Copyright © 2018年 XQ. All rights reserved.
//

import UIKit
import WSProgressHUD
import AVOSCloud
import AVOSCloudIM

class ViewController: UIViewController {
    
    @IBOutlet weak var myCallTextField: UITextField!
    @IBOutlet weak var otherCallTextField: UITextField!
    
    var myCall:String? = ""
    var otherCall:String? = ""
    
    @IBAction func leaveChannel(_ sender: UIButton) {
        AppDelegate.shared.leaveChannel()
    }
    @IBAction func joinChannel(_ sender: UIButton) {
        let page = InputCallNumberViewController.init(nibName: "InputCallNumberViewController", bundle: nil)
        self.present(page, animated: true, completion: { })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        myCall = UserDefaults.standard.object(forKey: myConstCallString) as? String
        otherCall = UserDefaults.standard.object(forKey: otherConstCallString) as? String
        //如果没有信息存在那么就弹输入信息界面，如果有信息存在那么久直接开始搞起。
        if confirmString(str: myCall) && confirmString(str: otherCall) { //用户存在不用弹界面了直接开始打电话
            callProgress(myCall!)
        } else {
            let page = InputCallNumberViewController.init(nibName: "InputCallNumberViewController", bundle: nil)
            self.present(page, animated: true, completion: { })
        }
    }
    
    func callProgress(_ channel:String) { //开始判断存储Installion流程
        
        if let s = pushcredentials {
            AppDelegate.shared.creatAVIDSaveToCloud(credentials: s, channelUnique: myCall!, completeHandle: {[unowned self] b in // leancloud
                
                if b {
                    self.joinChannel(channel: channel)
                } else {
                    Hud.showError("用户连接云端失败")
                }
            })
        } else {
            Hud.showError("信息获取错误，请重试")
        }
    }
    
    func joinChannel(channel:String) { // 开始加入频道流程、
        
        let num =  AppDelegate.shared.joinChannel(channel: channel) //设置过用户有效，开始进入自己的频道
        //let num =  AppDelegate.shared.joinChannel(channel: "tempChannel") //设置过用户有效，开始进入自己的频道

        if num == 0 { //加入房间成功，这时候发送推送给对方，让对方也接听了就进入房间。
            let push = AVPush.init()
            push.setChannel(otherCall!) //这里使用的前面已经判断过了
            push.setMessage(myCall!) //发送当前用户所在频道。
            push.sendInBackground({ (b, e) in
                if !b {
                    Hud.showError("通知对方失败，可能是对方正在忙碌中.")
                    print("error message ====> \(e.debugDescription)")
                } else {
                    print("sendInBackground ====> success")
                }
            })
        } else { // 为负数那么就说明加入房间失败了
            Hud.showError("进入房间失败，请重试")
        }
    }
}

