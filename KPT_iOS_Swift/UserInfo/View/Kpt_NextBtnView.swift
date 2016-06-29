//
//  Kpt_NextBtnView.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/27.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

protocol Kpt_NextBtnViewDelegate :NSObjectProtocol {
    func nextBtnClick(nextBtn:Kpt_NextBtnView)
}

class Kpt_NextBtnView: UIView {
    weak var delegate : Kpt_NextBtnViewDelegate? = nil
    var btnText:String? {
        didSet {
            creatNexBtn()
        }
    }
    var nextButton : UIButton!
    class func creatNextBtnView(frame:CGRect) ->Kpt_NextBtnView {
        let view = Kpt_NextBtnView(frame: frame)
        view.userInteractionEnabled = true
        return view
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func btnClick() {
        if (self.delegate != nil) {
            self.delegate?.nextBtnClick(self)
        }
    }
    private func creatNexBtn() {
        ///tableview的cell的主要高度
        let cellMainHeight:CGFloat = IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40
        let button = UIButton(type: UIButtonType.Custom)
        
        button.frame = CGRect(x: 50 , y: (self.frame.size.height - cellMainHeight)/2 , width: SCRW - 100, height: cellMainHeight)

        if btnText == "自行维修" {
            button.setImage(UIImage(named: "不完善"), forState: UIControlState.Selected)
        }else {
            button.setBackgroundImage(UIImage(named: "完善"), forState: UIControlState.Normal)
        }
        
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        button.layer.cornerRadius = cellMainHeight * 0.5
        
        button.setTitle(btnText, forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(22)
            
        button.addTarget(self, action: "btnClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(button)
        nextButton = button
    }

}
