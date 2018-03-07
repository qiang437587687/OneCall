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
import Alamofire

var airChannel = "" //1 外部连接的channel 拨打电话的时候是传出去的channel 接收方的时候是传过来的channel 2. 如果这个值得count 不是0 那么就不要拨打电话了。防止双端调起同时都打电话出去了

class ViewController: UIViewController {
    
    @IBOutlet weak var myCallTextField: UITextField!
    @IBOutlet weak var otherCallTextField: UITextField!
    
    var myCall:String? = ""
    var otherCall:String? = ""
    
    @IBAction func leaveChannel(_ sender: UIButton) {
        AppDelegate.shared.leaveChannel()
        //正在连接的频道。
        if airChannel != "" {
            
            sendOtherQuitChannel(otherChannel: airChannel)
            airChannel = ""
            Hud.showMassage("通话结束，5秒后退出应用")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                exit(0)
            }
            
        } else {
            Hud.showMassage("当前无通话")
        }
        
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
        //如果没有信息存在那么就弹输入信息界面，如果有信息存在那么久直接开始搞起。 airchannel == “”当前无通话
        if confirmString(str: myCall) && confirmString(str: otherCall) && (airChannel == "") { //用户存在不用弹界面了直接开始打电话
            callProgress(myCall!,otherChannel:otherCall!)
        } else {
            let page = InputCallNumberViewController.init(nibName: "InputCallNumberViewController", bundle: nil)
            self.present(page, animated: true, completion: { })
        }
    }
    
    func callProgress(_ channel:String,otherChannel:String) { //开始判断存储Installion流程
        
        if let s = pushcredentials {
            AppDelegate.shared.creatAVIDSaveToCloud(credentials: s, channelUnique: myCall!, completeHandle: {[unowned self] b in // leancloud
                
                if b {
                    self.joinChannel(channel: channel) // 1.自己加入房间
                    sendChannelToOther(channel, otherChannel: otherChannel)
                    airChannel = otherChannel //如果结束需要一起结束的。
                } else {
                    Hud.showError("用户连接云端失败")
                }
            })
        } else {
            Hud.showError("信息获取错误，请重试")
        }
    }
    
    
    @discardableResult
    func joinChannel(channel:String) ->Int { // 开始加入频道流程、
        
        return  AppDelegate.shared.joinChannel(channel: channel) //设置过用户有效，开始进入自己的频道
        
        /*
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
        */
    }
}

