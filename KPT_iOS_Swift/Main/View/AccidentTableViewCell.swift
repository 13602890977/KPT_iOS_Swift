//
//  AccidentTableViewCell.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/12.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

typealias selectCarType = (bl:Bool)->Void

class AccidentTableViewCell: UITableViewCell {
    @IBOutlet weak var notSelectedImage: UIImageView!

    @IBOutlet weak var selectImage: UIImageView!
    
    @IBOutlet weak var oneCarBtn: UIButton!
    @IBOutlet weak var twoCarBtn: UIButton!
    private var selectType:selectCarType!
    ///记录选择单车事故还是双车事故，true表示单车事故
    private var selectBool: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        twoCarBtn.enabled = false
        // Initialization code
    }

    @IBAction func oneCarBtnClick(sender: AnyObject) {
        selectImage.image = UIImage(named: "未选")
        notSelectedImage.image = UIImage(named: "已选")
        oneCarBtn.enabled = false
        twoCarBtn.enabled = true
        if self.selectType != nil {
            self.selectType(bl: selectBool)
        }
    }
    @IBAction func twoCarBtnClick(sender: AnyObject) {
        selectImage.image = UIImage(named: "已选")
        notSelectedImage.image = UIImage(named: "未选")
        oneCarBtn.enabled = true
        twoCarBtn.enabled = false
        if self.selectType != nil {
            self.selectType(bl: !selectBool)
        }
        
    }
    func returnSelectedResult(result:selectCarType) {
        self.selectType = result
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
