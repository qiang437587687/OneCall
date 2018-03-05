//
//  FLHud.swift
//  FLive
//
//  Created by BrikerMan on 2017/1/28.
//  Copyright © 2017年 BrikerMan. All rights reserved.
//

import Foundation
import WSProgressHUD

let Hud = FLHudView.shared

@objc class FLHudView: NSObject {
    
    @objc static let shared = FLHudView()
    
    var dismissTimeInterval = 3.0
    
    fileprivate typealias hud = WSProgressHUD
    
    @objc func showMassage(_ massage:String) {
        runOnMainThread {
            hud.showShimmeringString(massage)
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.dismiss), object: nil)
            self.perform(#selector(self.dismiss), with: nil, afterDelay: self.dismissTimeInterval)
        }
    }
    
    func showLoading(_ massage:String = "正在处理 ...", masked: Bool = false){
        runOnMainThread {
            if masked {
                hud.show(withStatus: massage, maskType: .gradient)
            } else {
                hud.show(withStatus: massage)
            }   
        }
    }
    
    func showLoadingWithMask(_ massage:String) {
        runOnMainThread {
            hud.showShimmeringString(massage, maskType: WSProgressHUDMaskType.black)
        }
        
    }
    
    func showError(_ massage:String?) {
        runOnMainThread {
            hud.showShimmeringString(massage ?? "未知错误")
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.dismiss), object: nil)
            self.perform(#selector(self.dismiss), with: nil, afterDelay: self.dismissTimeInterval)
        }
    }
    
    @objc func dismiss() {
        runOnMainThread {
            hud.dismiss()
        }
    }
    
    /*
    func showToastError(_ massage:String?) {
        runOnMainThread {
            FLToast.debugInfo(massage ?? "未知错误")
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.dismiss), object: nil)
            self.perform(#selector(self.dismiss), with: nil, afterDelay: self.dismissTimeInterval)
        }
    }
    
    @objc func toastDismiss() {
        runOnMainThread {
            FLToast.toast?.cancel()
        }
    }
    */
}
