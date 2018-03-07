//
//  CallkitExtensionAppdelegate.swift
//  OneCallEx
//
//  Created by zhangxianqiang on 2018/3/3.
//  Copyright © 2018年 XQ. All rights reserved.
//

import UserNotifications
import AVOSCloud
import AVOSCloudIM
import PushKit
import HandyJSON

let callManager = CallManager()
var providerDelegate: ProviderDelegate = ProviderDelegate(callManager: callManager)
var pushcredentials:PKPushCredentials? {
    didSet{
        //可能数据在使用之后才进行了设置。 所以这个地方需要注意一下。 后期优化。
    }
}

extension AppDelegate {
    
    func configInitValue() {
        configAVCloud()
        configPushKit()
        configAgora()
    }
    
    private func configAVCloud() {
        // 初始化推送相关
        AVOSCloud.setApplicationId("lqneCtEOG1bN2yTJ9gafPc20-gzGzoHsz", clientKey: "GxVivHpa9rnFo0GM7NAnLjqB")
        // 尝试保存一个标志位来代表保存的成功失败状态
        let obj = AVObject.init(className: "TestZhangSave")
        obj.setObject("bar", forKey: "foo")
        obj.save()
    }
    
    private func configPushKit() {
        let pushRegistry = PKPushRegistry.init(queue: nil)
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [PKPushType.voIP]
    }
    
}

extension AppDelegate { //电话的接听挂断方法
    func endCall() {
        
        callManager.calls.forEach { (c) in
            callManager.end(call: c)
        }
    }
    
    
    private func displayIncomingCall(nickname:String,uuid: UUID, handle: String, hasVideo: Bool = false,backStatu:@escaping callStatusBack , completion: ((NSError?) -> Void)?) {
        
        providerDelegate.reportIncomingCall(nickname: nickname, uuid: uuid, handle: handle, hasVideo: hasVideo, backStatus: backStatu, completion: completion)
    }
    
    func makeACall(nickname:String,handle:String,backStatu:@escaping callStatusBack) {
        
        if callManager.calls.count > 0 {
            Hud.showError("当前正在通话，又来一个电话，肯定是不行的~")
            return
        }
        
        let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now()) {
            print("handle = \(handle)")
            self.displayIncomingCall( nickname:nickname, uuid: UUID(), handle: handle, hasVideo: false,backStatu:backStatu) { _ in
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            }
        }
    }
    
}

extension AppDelegate : UNUserNotificationCenterDelegate,PKPushRegistryDelegate { // 代理方法
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        
//        print(payload.dictionaryPayload) //接收到推送了。
        let dic = payload.dictionaryPayload as NSDictionary
        let model = PushModel.deserialize(from: dic)
        
        tempShowTip(model?.rquestChannel ?? "居然是空的^.^")
        
        if model?.pushEvent == 0 { //打电话
            
            let myCall = UserDefaults.standard.object(forKey: myConstCallString) as? String
            let otherCall = UserDefaults.standard.object(forKey: otherConstCallString) as? String
            /*
             本地如果不存在数据那么就不要弹出callkit了,防止重新安装的时候没有登录账号还能打电话。
             */
            if confirmString(str: myCall) && confirmString(str: otherCall) {
                airChannel = model?.rquestChannel ?? "" //如果结束需要一起结束的记录。
                leaveChannel()
                encomingCall(model: model)
            } else {
                Hud.showMassage("上一次给你打电话的人，依然给你打来了电话。")
            }
        }
        
        if model?.pushEvent == 1 { //发送挂断信息
            tempShowTip("电话已经挂断")
            endCall()
            leaveChannel()
        }
        
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let token = getMeaningToken(credentials:pushCredentials)
        //打印出token看一下是不是有什么猫腻。
        print("token ====>>> \(token)")
        pushcredentials = pushCredentials
        //创建ID
//        creatAVIDSaveToCloud(credentials: pushCredentials)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
}

extension AppDelegate { //创建方法
    
    func creatAVIDSaveToCloud(credentials:PKPushCredentials,channelUnique:String,completeHandle:@escaping SimpleBoolClosure) {
        //let temp = AVInstallation.current()
        //保存对应的installtion
        //let insTempString = deleteVoipString(str: temp.objectId ?? "")
        let ins = AVInstallation.init(objectId: channelUnique + ConstStrting)
        ins.apnsTopic = "com.zhangxianqiang.onecall.voip"
        ins.setDeviceTokenFrom(credentials.token)
        ins.addUniqueObject(channelUnique, forKey: "channels")
        ins.saveInBackground { (b, e) in
            if b {print("save success")}
            completeHandle(b)
        }
        print("objectID ====== > \(ins.objectId ?? "")")
        
    }
    
    func deleteVoipString(str:String) -> String { //毛线方法为了避免leanCloud的bug ，WTF~？
        var temp = str
        if temp.hasSuffix(ConstStrting) {
            temp = temp.components(separatedBy: ConstStrting).first ?? ""
        }
        print("delete method : temp ======> \(temp)")
        return temp
    }
}


extension AppDelegate { // appdelegate 这个是逻辑处理
    
    func encomingCall(model:PushModel?) {
        if model?.rquestChannel.count == 0 {
            Hud.showError("消息在空中飞丢了")
        } else {
            //            joinChannel(channel: model!.rquestChannel) //加入频道。
            //            makeACall(nickname: model!.rquestChannel, handle: model!.rquestChannel, backStatu: )
            makeACall(nickname: model!.rquestChannel, handle: model!.rquestChannel, backStatu: { [unowned self] (status) in
                
                switch (status) {
                case .answer: //这就开始打电话了 ---> 按照原来的逻辑
                    
                    let num = self.joinChannel(channel: model!.rquestChannel)
                    
                    if num != 0 { //加入房间失败， 通知对方有错误
                        
                    }
                    
                case .end:
                    
                    // 需要发送一个通知给对方告知已经挂断了。
                    self.leaveChannelNoti()
                    let num = self.leaveChannel()
                    if num != 0 { //退出房间失败
                        
                    }
                    
                case .hole:
                    print("留空")
                case .error:
                    print("error")
                }
                
            })
        }
    }
    
}


















