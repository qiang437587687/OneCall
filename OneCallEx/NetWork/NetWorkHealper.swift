//
//  NetWorkHealper.swift
//  OneCallEx
//
//  Created by zhangxianqiang on 2018/3/7.
//  Copyright © 2018年 XQ. All rights reserved.
//

import Foundation
import Alamofire

//let mainUrl = "http://onecallex.leancloud.cn"
//let mainUrl = "http://localhost:3000"
let mainUrl = "http://192.168.11.234:5000"

func sendChannelToOther(_ channel:String,otherChannel:String) { //所有的message都代表着other的频道，
    
    Alamofire.request( mainUrl+"/pushchannel", method: .post, parameters: ["channel":channel,"otherChannel":otherChannel], encoding: URLEncoding.default, headers: nil).responseJSON { (respone) in
        print("respone - - - - - - - >")
        print(respone.error)
        print(respone.description)
        print(respone.data)
    }
    
}

func sendOtherQuitChannel(otherChannel:String) { //通知对方已经挂断了
    Alamofire.request(mainUrl+"/leavechannel", method: .post, parameters: ["otherChannel":otherChannel], encoding: URLEncoding.default, headers: nil).responseJSON { (respone) in
        print("respone - - - - - - - >")
        print(respone.error)
        print(respone.description)
        print(respone.data)
    }
}
