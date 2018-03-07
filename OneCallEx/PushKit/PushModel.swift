//
//  PushModel.swift
//  OneCallEx
//
//  Created by zhangxianqiang on 2018/3/6.
//  Copyright © 2018年 XQ. All rights reserved.
//

import Foundation
import HandyJSON
/*
 
 [AnyHashable("rquestChannel"): 13255353553, AnyHashable("aps"): {
 alert = "\U6d88\U606f\U5185\U5bb9";
 category = "\U901a\U77e5\U7c7b\U578b";
 "thread-id" = "\U901a\U77e5\U5206\U7c7b\U540d\U79f0";
 }, AnyHashable("version"): 3月6号晚上23.22]
 
 */

struct PushModel: HandyJSON {
    var rquestChannel:String = ""
    var aps : PushModelAps?
    var version:String = ""
}

struct PushModelAps: HandyJSON {
    var alert:String = ""
    var category:String = ""
//    var thread-id:String = ""
}

