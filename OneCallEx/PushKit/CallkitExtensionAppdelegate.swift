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
    
}

extension AppDelegate : UNUserNotificationCenterDelegate,PKPushRegistryDelegate { // 代理方法
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        
        print(payload.dictionaryPayload) //接收到推送了。
        print("did konw") //currentTopVc()
        
        leaveChannel()
        joinChannel(channel: "tempChannel")
        
        let alertController = UIAlertController(title: "系统提示",
                                                message: "您确定要离开hangge.com吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {action in
            print("点击了确定")
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        currentTopVc().present(alertController, animated: true, completion: nil)
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



















