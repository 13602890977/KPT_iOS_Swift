//
//  AgreementViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/7/1.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MBProgressHUD

class AgreementViewController: UIViewController {

    
    ///用于接收车辆信息(选择责任分担之后)
    var partiesdataArr : NSMutableArray!
    ///当事人信息(主要包含任务id和当事人id)
    var responsibilitydata:NSDictionary!
    ///流程id
    var flowid : String!
    
    @IBOutlet weak var mainWebView: UIWebView!
    
    ///协议书接口str
    var protocolsrc : String!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = MainColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "责任认定协议书"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "展开"), style: UIBarButtonItemStyle.Plain, target: self, action: "disSelfView")
        self.navigationItem.leftBarButtonItem?.tintColor = MainColor
        
        self.mainWebView.loadRequest(NSURLRequest(URL: NSURL(string: protocolsrc)!))
        
        // Do any additional setup after loading the view.
    }
    ///在线定损(双车)
    @IBAction func insuranceBtnClick(sender: AnyObject) {
        let onlineVC = OnlineInsuranceViewController(nibName:"OnlineInsuranceViewController",bundle: nil)
        
        onlineVC.carType = "twoCar"
        onlineVC.carDataArr = self.partiesdataArr
        onlineVC.responsibilitydata = self.responsibilitydata
        self.navigationController?.pushViewController(onlineVC, animated: true)
        
    }
    @IBAction func reportBtnClick(sender: AnyObject) {
    }
    ///点击左侧导航栏返回键
    func disSelfView() {
//        if #available(iOS 8.0, *) {
            let alertC = UIAlertController(title: nil, message: "是否退出此任务？\n\n", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "继续", style: UIAlertActionStyle.Default) { (action) -> Void in
                alertC.dismissViewControllerAnimated(true, completion: nil)
            }
            cancelAction .setValue(MainColor, forKey: "titleTextColor")
            alertC.addAction(cancelAction)
            
            let action = UIAlertAction(title: "退出", style: UIAlertActionStyle.Cancel) { (action) -> Void in
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
            action.setValue(UIColor.grayColor(), forKey: "titleTextColor")
            alertC.addAction(action)
            
            self.presentViewController(alertC, animated: true, completion: nil)
//        } else {
//            // Fallback on earlier versions
//        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AgreementViewController : UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        self.hud.labelText = "加载中..."
        self.hud.show(true)
    }
    func webViewDidFinishLoad(webView: UIWebView) {
//        print(webView)
        self.hud.hide(true)
        
        let title = webView.stringByEvaluatingJavaScriptFromString("document.title")
        print(title)
//        let js_result = webView.stringByEvaluatingJavaScriptFromString("document.getElementsByName('q')[0].value='wocao';")
//        print(js_result)
    }
}
