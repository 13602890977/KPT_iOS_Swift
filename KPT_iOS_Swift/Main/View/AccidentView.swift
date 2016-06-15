//
//  AccidentView.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/12.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
protocol AccidentViewDelegate:AnyObject {
    func removeFromAccidentView(view:AccidentView)
}
class AccidentView: UIView,UIScrollViewDelegate,UITextViewDelegate {
    
    
    weak var delegate:AccidentViewDelegate!
    
    class func creatAccidentBackgroundViewWith(frame frame:CGRect,controller:UIViewController) -> AccidentView {
        let view = AccidentView(frame: frame)
        view.userInteractionEnabled = true
        view.backgroundColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 218/255.0, alpha: 0.9)
        
        
        view.addSubview(view.scrollView)
        view.scrollView.frame = CGRect(x: 25, y: 30 + 64 - SCRW, width: SCRW - 50, height: SCRH - 124)
        
        UIView.animateWithDuration(0.5) { () -> Void in
            
            view.scrollView.frame = CGRect(x: 25, y: 30 + 64, width: SCRW - 50, height: SCRH - 124)
        }
        view.addSubview(view.pageControl)
        view.addSubview(view.closeBtn)
        return view
        
    }
    ///关闭按钮点击事件
    func closeBtnClick() {
//        if self.delegate != nil {
//            self.delegate.removeFromAccidentView(self)
//        }
        self.removeFromSuperview()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var closeBtn:UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.frame = CGRect(x: self.scrollView.frame.origin.x + self.scrollView.frame.size.width - 34, y: self.scrollView.frame.origin.y + 10, width: 24, height: 24)
        button.setBackgroundImage(UIImage(named: "关闭"), forState: UIControlState.Normal)
        button.addTarget(self, action: "closeBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    ///温馨提醒的scrollview展示
    private lazy var scrollView:UIScrollView = {
        let scroll = UIScrollView(frame: CGRect(x: 25, y: 30 + 64, width: SCRW - 50, height: SCRH - 124))
        scroll.pagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.backgroundColor = UIColor.whiteColor()
        scroll.contentSize = CGSize(width: scroll.frame.size.width * 2, height: 0)
        scroll.delegate = self
        //添加固定提示语和图片，没有图片，只能自己写了
        let tipLabelTextArr = ["发生交通事故后，请立即开启双闪警示灯","夜间还需开启廊灯和后灯","请在车后方放置警示牌"]
        var label = UILabel()
        //第一页的提示语和图片
        for var i = 0 ; i < 3 ; i++ {
            let tipImage = UIImageView(frame: CGRect(x: 10, y: 49 + 30*i, width: 15, height: 15))
            tipImage.image = UIImage(named: "round_y")
            scroll.addSubview(tipImage)
            
            let tipLabel = UILabel(frame: CGRect(x: 35, y: 49 + 30*i, width: Int(scroll.frame.size.width) - 59, height: 15))
            
            tipLabel.text = tipLabelTextArr[i]
            tipLabel.font = UIFont.systemFontOfSize(15)
            tipLabel.numberOfLines = 0
            tipLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            scroll.addSubview(tipLabel)
            label = tipLabel
        }
        let tipImage = UIImageView(frame: CGRect(x: 40, y: label.frame.origin.y + label.frame.size.height + 10, width: scroll.frame.size.width - 80, height: (scroll.frame.size.width - 80) / 393 * 562))
        tipImage.image = UIImage(named: "警示牌")
        scroll.addSubview(tipImage)
        
        //第二页的界面设置
        let scrollViewWidth = scroll.frame.size.width
        let tipTextView = UITextView(frame: CGRect(x: scrollViewWidth + 20, y: 49, width: scrollViewWidth - 40, height: 100))
        tipTextView.delegate = self
//        tipTextView.text = "任何一方有一下情形之一的，驾驶人应立即报警，在现场等待交警处理，无以下情形的继续处理"
//        tipTextView.font = UIFont.systemFontOfSize(15)
        
        //设置字体行间距
        // textview 改变字体的行间距
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10;// 字体的行间距
        
        let attributes = [
            NSFontAttributeName:UIFont.systemFontOfSize(15),
            NSParagraphStyleAttributeName:paragraphStyle
        ]
        tipTextView.attributedText = NSAttributedString(string: "任何一方有一下情形之一的，驾驶人应立即报警，在现场等待交警处理，无以下情形的继续处理", attributes: attributes)
        
        scroll.addSubview(tipTextView)
        
        let btnWidth:CGFloat = 200
        let btnHeight:CGFloat = 40
        //在第二页下面添加button(立即报警)
        let button = UIButton(type: UIButtonType.System)
        button.frame = CGRect(x: scroll.frame.size.width + (scroll.frame.size.width - btnWidth) * 0.5, y: scroll.frame.height - btnHeight - 30, width: btnWidth, height: btnHeight)
        button.backgroundColor = MainColor
        button.setTitle("立即报警", forState: UIControlState.Normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFontOfSize(20)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: "callPoliceBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        scroll.addSubview(button)
        
        let imageWidth = (scrollViewWidth - 80) * 0.5 - 20
        let imageNameArr = ["受伤","无牌","无驾照","酒驾"]
        for var i = 0 ; i < 4;i++ {
            let image = UIImageView(frame: CGRect(x: CGFloat(Int(scrollViewWidth) + 40 + (i % 2) * (Int(imageWidth) + 30)), y: tipTextView.frame.height + tipTextView.frame.origin.y + 10 + CGFloat((i / 2) * (Int(imageWidth) + 30)), width: imageWidth, height: imageWidth+10))
            image.image = UIImage(named: imageNameArr[i])
            scroll.addSubview(image)
        }
        return scroll
    }()
    ///立即报警按钮点击事件
    func callPoliceBtnClick() {
        print("立即报警")
    }
    ///温馨提醒的页数标记
    private lazy var pageControl:UIPageControl = {
        let pageControl = UIPageControl(frame: CGRect(x: (self.scrollView.frame.size.width ) * 0.5, y: self.scrollView.frame.origin.y + self.scrollView.frame.size.height - 10, width: 40, height: 0))
        pageControl.numberOfPages = 2
        //没有选择的page的颜色
        pageControl.pageIndicatorTintColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 218/255.0, alpha: 0.9)
        //选中的page的颜色
        pageControl.currentPageIndicatorTintColor = MainColor
        return pageControl
    }()
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //计算页码
        //页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
       let scrollviewW =  scrollView.frame.size.width;
       let x = scrollView.contentOffset.x;
       let page = (x + scrollviewW / 2) /  scrollviewW;
       self.pageControl.currentPage = Int(page);
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return false
    }
}
