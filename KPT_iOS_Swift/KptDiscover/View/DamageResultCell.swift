//
//  DamageResultCell.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/25.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class DamageResultCell: UITableViewCell {

    var positionDict : NSMutableDictionary! {
        didSet {
            positionLabel.text = positionDict.objectForKey("partname") as? String
            degreeLabel.text = positionDict.objectForKey("damagedlevel") as? String
            costLabel.text = positionDict.objectForKey("fixprice") as? String
        }
    }
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
