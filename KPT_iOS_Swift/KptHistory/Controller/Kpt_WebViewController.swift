//
//  Kpt_WebViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/7/6.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MBProgressHUD

class Kpt_WebViewController: UIViewController,UIWebViewDelegate {
    ///协议书接口str
    var protocolsrc : String!
    
    ///接口title
    var protocolTitle : String?
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = MainColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = protocolTitle
        
        self.navigationItem.leftBarButtonItem?.tintColor = MainColor
        self.view = self.mainWebView
        self.mainWebView.loadRequest(NSURLRequest(URL: NSURL(string: protocolsrc)!))
        // Do any additional setup after loading the view.
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.hud.labelText = "加载中..."
        self.hud.show(true)
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        //        print(webView)
        self.hud.hide(true)
    }

    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    private lazy var mainWebView : UIWebView = {
       let webView = UIWebView(frame: self.view.bounds)
        webView.delegate = self
        return webView
    }()
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
