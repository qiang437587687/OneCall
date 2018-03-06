//
//  InputCallNumberViewController.swift
//  OneCallEx
//
//  Created by zhangxianqiang on 2018/3/5.
//  Copyright © 2018年 XQ. All rights reserved.
//

import UIKit

class InputCallNumberViewController: UIViewController {

    @IBOutlet weak var mycallNumberTextField: UITextField!
    @IBOutlet weak var otherNumberTextfield: UITextField!
    @IBAction func confirmButton(_ sender: UIButton) {
        
        //暂时不做校验
        let myCall = mycallNumberTextField.text ?? ""
        let otherCall = otherNumberTextfield.text ?? ""
        
        //存储自己的号码和对方的号码
        UserDefaults.standard.set(myCall, forKey: myConstCallString)
        UserDefaults.standard.set(otherCall, forKey: otherConstCallString)
        
        self.dismiss(animated: true) {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
