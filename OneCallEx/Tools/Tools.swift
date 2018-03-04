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
