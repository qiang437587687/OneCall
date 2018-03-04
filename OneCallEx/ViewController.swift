//
//  ViewController.swift
//  OneCallEx
//
//  Created by zhangxianqiang on 2018/2/24.
//  Copyright © 2018年 XQ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func leaveChannel(_ sender: UIButton) {
        AppDelegate.shared.leaveChannel()
    }
    @IBAction func joinChannel(_ sender: UIButton) {
        
        AppDelegate.shared.joinChannel(channel: "zhangxianqiang1")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

