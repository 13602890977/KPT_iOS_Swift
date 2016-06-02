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
    
    class func creatNextBtnView(frame:CGRect) ->Kpt_NextBtnView {
        let view = Kpt_NextBtnView(frame: frame)
        view.userInteractionEnabled = true
        return view
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatNexBtn()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func btnClick() {
        print("点击了下一步")
        if (self.delegate != nil) {
            self.delegate?.nextBtnClick(self)
        }
    }
    private func creatNexBtn() {
        let button = UIButton(type: UIButtonType.System)
        button.frame = CGRect(x: 100 / 2 , y: (self.frame.size.height - 30)/2 , width: SCRW - 100, height: 30)
        button.backgroundColor = UIColor.RGBA(187, g: 165, b: 67)
        button.setTitleColor(UIColor.RGBA(146, g: 108, b: 52), forState: UIControlState.Normal)
        button.layer.cornerRadius = 15
        
        button.setTitle("下一步", forState: UIControlState.Normal)
        button.addTarget(self, action: "btnClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(button)
        
    }

}
