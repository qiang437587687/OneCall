
//
//  AgoraAppdelegateExtension.swift
//  OneCallEx
//
//  Created by zhangxianqiang on 2018/3/3.
//  Copyright © 2018年 XQ. All rights reserved.
//

//声网相关的 设置和代理
var agoraKit : AgoraRtcEngineKit?

extension AppDelegate:AgoraRtcEngineDelegate {
    
    func configAgora() {
        if agoraKit == nil {
            agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "6331cdb3598b461f98257efd4a62249f", delegate: self)
        }
    }
    //*  @return 0 when executed successfully, and return negative value when failed.
    @discardableResult
    func joinChannel(channel:String) -> Int {
        
        guard let ag = agoraKit else  {
            print("没初始化")
            return -1
        }
        
        return Int(ag.joinChannel(byKey: nil, channelName: channel, info:nil, uid:0) {(sid, uid, elapsed) -> Void in
            // Joined channel "demoChannel"
            ag.setEnableSpeakerphone(true)
            UIApplication.shared.isIdleTimerDisabled = true
        })
    }
    
    @discardableResult
    func leaveChannel() -> Int {
        guard let ag = agoraKit else  {
            print("没初始化")
            return -100
        }
        
        let statusNumber = ag.leaveChannel { (status) in }
        
        return Int(statusNumber)
        
    }
    
    func leaveChannelNoti() { //发送离开房间的通知。
        
        
        
    }
    
    func rtcEngineMediaEngineDidLoaded(_ engine: AgoraRtcEngineKit) {
        print("rtcEngineMediaEngineDidLoaded")
    }
    
}



