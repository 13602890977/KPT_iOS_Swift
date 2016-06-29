//
//  RepairCell.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/27.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class RepairCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var repairModel : RepairModel! {
        didSet {
            self.nameLabel.text = repairModel.name
            self.distanceLabel.text = repairModel.distance.stringValue + "米"
            self.addressLabel.text = repairModel.address
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func gotoButtonClick(sender: AnyObject) {
        print("去这里")
    }
    @IBAction func navigationButtonClick(sender: AnyObject) {
        print("导航")
    }
    @IBAction func photoButtonClick(sender: AnyObject) {
        print("电话")
    }
    @IBAction func detailsButtonClick(sender: AnyObject) {
        print("详情")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
