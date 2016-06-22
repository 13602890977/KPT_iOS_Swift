//
//  OnlineInsuranceViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/22.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class OnlineInsuranceViewController: UIViewController {
    ///车牌号码
    @IBOutlet weak var carnoLabel: UILabel!
    ///接收车牌号码
    var carnoStr : String!
    ///车型
    @IBOutlet weak var carModelLabel: UILabel!
    ///接收车型
    var carmodelStr : String!
    ///受损部位label
    @IBOutlet weak var partLabel: UILabel!
    ///显示车受损位置图片
    @IBOutlet weak var MainScrolleView: UIScrollView!
    ///显示图片个数
    @IBOutlet weak var pageView: UIPageControl!
    ///点击进入下一步(需要区分双车和单车,双车显示下一步，进入对方车辆受损界面，单车直接提交数据)
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.carnoLabel.text = carnoStr
        self.carModelLabel.text = carmodelStr
        
        self.MainScrolleView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension OnlineInsuranceViewController : UIScrollViewDelegate {
    
}
