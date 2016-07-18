//
//  KptStartupViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/7/18.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class KptStartupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(mainScrollView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private lazy var mainScrollView : UIScrollView = {
       let scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
        scrollView.backgroundColor = UIColor.orangeColor()
        scrollView.delegate = self
        //翻页模式
        scrollView.pagingEnabled = true
        //隐藏
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: SCRW * 4, height: SCRH)
//        scrollView.t
        var lastImage = UIImageView()
        for i in 0 ..< 4 {
            let imageView = UIImageView(frame: CGRect(x: SCRW * CGFloat(i), y: 0, width: SCRW, height: SCRH))
            imageView.image = UIImage(named: "\(i+1).jpg")
            scrollView.addSubview(imageView)
            lastImage = imageView
        }
        self.setLastImageViewBtn(lastImage)
        return scrollView
    }()

    private func setLastImageViewBtn(imageView : UIImageView) {
        let button = UIButton(type: UIButtonType.System)
        button.frame = CGRect(x: SCRW * 0.25, y: SCRH - SCRH*120/736.0, width: SCRW * 0.5, height: 50)
        button.addTarget(self, action: "lastImageBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
//        button.backgroundColor = UIColor.redColor()
        imageView.userInteractionEnabled = true
        imageView.addSubview(button)
    }
    
    func lastImageBtnClick() {
        let window = UIApplication.sharedApplication().keyWindow
        window?.rootViewController = MainAppViewController()
        window?.makeKeyAndVisible()
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
extension KptStartupViewController : UIScrollViewDelegate {
    
}