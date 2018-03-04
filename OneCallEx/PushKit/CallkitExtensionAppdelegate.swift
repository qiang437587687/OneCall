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
        print("did konw")
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let token = getMeaningToken(credentials:pushCredentials)
        //打印出token看一下是不是有什么猫腻。
        print("token ====>>> \(token)")
        //创建ID
        creatAVIDSaveToCloud(credentials: pushCredentials)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }

    
}


extension AppDelegate { //创建方法
    
    func creatAVIDSaveToCloud(credentials:PKPushCredentials) {
        let temp = AVInstallation.current()
        //保存对应的installtion
        let insTempString = deleteVoipString(str: temp.objectId ?? "")
        let ins = AVInstallation.init(objectId: insTempString + ConstStrting)
        ins.apnsTopic = "com.zhangxianqiang.onecall.voip"
        ins.setDeviceTokenFrom(credentials.token)
        ins.saveInBackground()
        print("objectID")
        print(ins.objectId ?? "")
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



















