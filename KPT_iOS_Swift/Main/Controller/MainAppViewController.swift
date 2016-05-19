//
//  MainAppViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/18.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MapKit

class MainAppViewController: UIViewController {
    ///地图定位管理者
    var locManager  :CLLocationManager?
    ///地理编码器
    var currentCityGeocoder :CLGeocoder?
    ///首页VC
    var KptHome     :KPTHomePageViewController?
    ///历史VC
    var KptHistory  :KPTHistoryViewController?
    ///发现VC
    var KptDiscover :KPTDiscoverViewController?
    
    let arrT = ["首页","发现","历史"]
    
    override func viewWillAppear(animated: Bool) {
        self.setNeedsStatusBarAppearanceUpdate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()
        view.backgroundColor = UIColor.whiteColor()
        
        _topNaviV.backgroundColor = UIColor.RGBA(49, g: 51, b: 67)
        _topNaviV.userInteractionEnabled = true
        _topNaviV.frame = CGRect(x: 0, y: 20, width: UIScreen.mainScreen().bounds.width, height: MENU_HEIGHT)
        view.addSubview(_topNaviV)
        
        //控件frame不要放入懒加载
        _scrollV.frame = CGRect(x: 0, y: self._topNaviV.frame.origin.y + self._topNaviV.frame.size.height, width:self.view.frame.size.width, height: self.view.frame.size.height - 64)
        
        view.addSubview(_scrollV)
        view.insertSubview(_scrollV, belowSubview: _topNaviV)
        //创建自定义导航条
        creatTopNaviVBtn()
        //在_scrollV中添加VC
        addChildVCInScroller()
        UIColor.randomColor()
    }

    //在主界面创建scrollView，创建三个VC的view，添加到主界面上
    private func addChildVCInScroller() {
        self.KptHome = KPTHomePageViewController()
        KptHome?.view.frame = CGRect(x: _scrollV.frame.size.width * 0, y: 0, width: _scrollV.frame.size.width, height: _scrollV.frame.height)
        _scrollV.addSubview(KptHome!.view)
        
        KptDiscover = KPTDiscoverViewController()
        KptDiscover?.view.frame = CGRect(x: _scrollV.frame.width, y: 0, width: _scrollV.frame.width, height: _scrollV.frame.height)
        _scrollV.addSubview(KptDiscover!.view)
        
        KptHistory = KPTHistoryViewController()
        KptHistory?.view.frame = CGRect(x: _scrollV.frame.width * 2, y: 0, width: _scrollV.frame.width, height: _scrollV.frame.height)
        _scrollV.addSubview(KptHistory!.view)
        
        _scrollV.contentSize = CGSize(width: _scrollV.frame.width * 3, height: _scrollV.frame.height)
        
    }
    private func creatTopNaviVBtn() {
        let btnW :CGFloat = 40
        let btnRight = UIButton(type: UIButtonType.Custom)
        btnRight.frame = CGRect(x: self._topNaviV.frame.width - btnW, y: 32, width: 30, height: 30)
        btnRight.setImage(UIImage(named: "Kpt_person"), forState: UIControlState.Normal)
        view.addSubview(btnRight)
        
        for var i = 0;i < arrT.count; i++ {
            let btn = UIButton(type: UIButtonType.Custom)
            btn.frame = CGRect(x: MENU_BUTTON_WIDTH * CGFloat(i), y: 0, width: MENU_BUTTON_WIDTH, height: MENU_HEIGHT)
            btn.setTitle(arrT[i], forState: UIControlState.Normal)

            btn.setTitleColor(UIColor.RGBA(242, g: 170, b: 3), forState: UIControlState.Normal)
            btn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: MIN_MENU_FONT)
            btn.tag = i + 1
            if i == 0 {
               btn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: MAX_MENU_FONT)
            }else {
                btn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: MIN_MENU_FONT)
            }
            btn.addTarget(self, action:"actionbtn:", forControlEvents: UIControlEvents.TouchUpInside)
            _navScroll.addSubview(btn)
        }
        //加上一个横线
        let shadowImageView = UIImageView(frame:CGRect(x: 0, y: 0, width: MENU_BUTTON_WIDTH, height: MENU_HEIGHT));
        shadowImageView.tag = 10000;
        shadowImageView.image = UIImage(named: "Kpt_line")
        
        _navScroll.addSubview(shadowImageView)
        
        _navScroll.setContentOffset(CGPoint(x: MENU_BUTTON_WIDTH * CGFloat(arrT.count), y: MENU_HEIGHT), animated: true)
        _navScroll.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: MENU_HEIGHT)
        _topNaviV.addSubview(_navScroll);
    }
    //导航条上button的点击事件
    func actionbtn(btn:UIButton) {
        _scrollV.scrollRectToVisible(CGRect(x: _scrollV.frame.width * CGFloat(btn.tag - 1), y: _scrollV.frame.origin.y, width: _scrollV.frame.width, height: _scrollV.frame.height), animated: true)
        
        //计算导航条btn的宽度变化值
        let btnX:CGFloat = _scrollV.frame.width * CGFloat(btn.tag - 1) * (MENU_BUTTON_WIDTH / view.frame.width) - MENU_BUTTON_WIDTH
        _navScroll.scrollRectToVisible(CGRect(x: btnX, y: 0, width: _navScroll.frame.width, height: _navScroll.frame.height), animated: true)
        
    }
    private func setStatusBar() {
        let viewV = UIView(frame: CGRect(x: 0, y: -20, width: 0, height: 0))
        viewV.backgroundColor = UIColor.RGBA(49, g: 51, b: 67)
        view.addSubview(viewV)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    ///导航条位置上的自定义ScrollView
    private lazy var _navScroll:UIScrollView = {
        let scroller = UIScrollView()
        return scroller
    }()
    ///导航条位置View
    private lazy var _topNaviV:UIView = UIView()
    ///主界面scrollView
    private lazy var _scrollV:UIScrollView = {
        let scroll = UIScrollView()
        scroll.bounces = false
        scroll.pagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self
        return scroll
    }()

}

extension MainAppViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == _scrollV {
            changeView(scrollView.contentOffset.x)
        }
        
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let xx = scrollView.contentOffset.x * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;
        
        _navScroll.scrollRectToVisible(CGRect(x: xx, y: 0, width: _navScroll.frame.width, height: _navScroll.frame.height), animated: true)
        
    }
    func changeView(offSet:CGFloat) {
        let setX = offSet * (MENU_BUTTON_WIDTH / view.frame.width)
        let sT: Int = Int(offSet / _scrollV.frame.width) + 1
        print(offSet)
        if sT <= 0  {
            return
        }
        let btn = _navScroll.viewWithTag(sT) as! UIButton
        let percent = (setX - MENU_BUTTON_WIDTH * CGFloat(sT - 1)) / MENU_BUTTON_WIDTH
        let value = MIN_MENU_FONT + (1 - percent) * (MAX_MENU_FONT - MIN_MENU_FONT);
        btn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: value)
        btn.tintColor = UIColor.whiteColor()
        
        //将下划线移动到选中的btn下方
        let image = _navScroll.viewWithTag(10000)
        image?.frame = CGRect(x: MENU_BUTTON_WIDTH * CGFloat(sT - 1), y: 0, width: MENU_BUTTON_WIDTH, height: MENU_HEIGHT)
        
        //设置未被选中的btn的变化
        if setX % MENU_BUTTON_WIDTH == 0  {
            return
        }
        let otherBtn = _navScroll.viewWithTag(sT + 1) as! UIButton
        let otherValue = MIN_MENU_FONT + percent * (MAX_MENU_FONT - MIN_MENU_FONT);
        otherBtn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: otherValue)
        otherBtn.tintColor = UIColor.whiteColor()
        
    }
}
