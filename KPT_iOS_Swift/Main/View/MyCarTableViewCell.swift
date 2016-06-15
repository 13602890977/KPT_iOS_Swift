//
//  MyCarTableViewCell.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/13.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class MyCarTableViewCell: UITableViewCell {

    @IBOutlet weak var roundImage: UIImageView!
    @IBOutlet weak var myCarName: UILabel!
    var carModel : MyCarModel! {
        didSet {
            myCarName.text = carModel.carno
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
