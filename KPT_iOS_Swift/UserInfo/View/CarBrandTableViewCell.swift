//
//  CarBrandTableViewCell.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/1.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import SDWebImage

class CarBrandTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var carTextLabel: UILabel!
    ///接收数据
    var model:CarBrandModel! {
        didSet {
            self.logoImage.sd_setImageWithURL(NSURL(string: "http://59.41.39.55:9090\(model.brandlogo)"))
            self.carTextLabel.text = model.brandname
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func creatBrandCellWithTableView(tableView:UITableView) ->CarBrandTableViewCell {
        let carBrandCellIndetifier = "carBrandCellIndetifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(carBrandCellIndetifier) as? CarBrandTableViewCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("CarBrandTableViewCell", owner: nil, options: nil).last as? CarBrandTableViewCell
            
        }
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell!
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
