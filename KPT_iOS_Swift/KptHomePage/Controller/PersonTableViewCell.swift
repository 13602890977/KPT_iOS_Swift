//
//  PersonTableViewCell.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/3.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var personIcon: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personPhoto: UILabel!
    @IBOutlet weak var QRcodeIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
