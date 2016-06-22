//
//  KPTDiscoverVController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/16.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class KPTDiscoverVController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        // Do any additional setup after loading the view.
    }

    @IBAction func insuranceBtnClick(sender: AnyObject) {
        print("在线定损")
        var nav : UINavigationController!
        if NSUserDefaults.standardUserDefaults().objectForKey("userInfoLoginData") == nil {
            nav = UINavigationController(rootViewController: Kpt_LoginViewController(nibName: "Kpt_LoginViewController", bundle: nil))
        }else {
            let myCarVC = MyCarViewController()
            myCarVC.isWhatControllerPushIn = "discoverVC"
           
            nav = UINavigationController(rootViewController: myCarVC)
            
        }
         let vc = UIApplication.sharedApplication().keyWindow?.rootViewController
        
            vc!.presentViewController(nav, animated: true, completion: nil)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
