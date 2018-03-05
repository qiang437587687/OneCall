//
//  Functions.swift
//  fengmi
//
//  Created by Eliyar Eziz on 16/3/29.
//  Copyright © 2016年 BAOFENG. All rights reserved.
//

import Foundation

//延迟函数
func delay(_ seconds: Double, completion:@escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}

/**
 主线程运行
 
 - parameter block: 主线程运行的block部分
 */
func runOnMainThread(_ block:@escaping ()->()) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}

/**
 后台线程运行
 
 - parameter block:  后台线程运行的block部分
 */
func runOnBackThread(_ block:@escaping ()->()) {
    DispatchQueue.global(qos: .background).async {
        block()
    }
}

class DelayItem {
    var item: DispatchWorkItem
    
    @discardableResult
    class func delay(_ seconds: Double, queue: DispatchQueue = DispatchQueue.main, _ block:@escaping ()->()) -> DelayItem {
        let task = DispatchWorkItem { block() }
        queue.asyncAfter(deadline: DispatchTime.now() + seconds, execute: task)
        return DelayItem(task)
    }
    
    init(_ item: DispatchWorkItem) {
        self.item = item
    }
    
    
    func cancel() {
        item.cancel()
    }
}


//extension YYWebImageManager {
//   static func cacheSize() ->String {
//        let diskCache = YYImageCache.shared().diskCache
//
//        let sdWebImageCacheFileSize = float_t(diskCache.totalCost())
//
//        var totleSize = sdWebImageCacheFileSize / 1024.0 / 1024.0
//
//        let addString = totleSize > 1 ? "M" : "K"
//
//        totleSize = totleSize > 1 ?totleSize : totleSize * 1024.0
//
//        return String(format: "%.2f", totleSize) + "\(addString)"
//    }
//}
