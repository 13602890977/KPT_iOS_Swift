//
//  MyPhotoEvidenceView.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/18.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

protocol MyPhotoEvidenceViewDelegate : AnyObject  {
    func backBtnClick()
    func photoButtonClick()
    func flashButtonClick()
}
class MyPhotoEvidenceView: UIView {

    weak var delegate : MyPhotoEvidenceViewDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var toolView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var flashbulbBtn: UIButton!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 0.5))
        self.promptLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 0.5))
    }
   
    @IBAction func flashbulbBtnTouch(sender: AnyObject) {
        if self.delegate != nil {
            self.delegate?.flashButtonClick()
        }
    }
    @IBAction func photoBtnTouch(sender: AnyObject) {
        if self.delegate != nil {
            self.delegate?.photoButtonClick()
        }
    }
    @IBAction func backBtnTouch(sender: AnyObject) {
        if self.delegate != nil {
            self.delegate?.backBtnClick()
        }
    }
//    override func drawRect(rect: CGRect) {
//        // Drawing code
//    }


}
