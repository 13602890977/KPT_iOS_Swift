//
//  HistoryCell.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/17.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

   
    @IBOutlet weak var processingLabel: UILabel!
    @IBOutlet weak var accidentType: UILabel!
    @IBOutlet weak var accidentAddress: UILabel!
    @IBOutlet weak var accidentTimeLabel: UILabel!
    @IBOutlet weak var carPhotoImage: UIImageView!
    @IBOutlet weak var carnoLabel: UILabel!
    
    ///用于接收数/Users/jacks/Desktop/KPT_iOS_Swift/KPT_iOS_Swift/KptHistory/View/HistoryDetailsCell.swift据
    var historyModel:HistoryModel! {
        didSet {
            carnoLabel.text = historyModel.partiescarno
            accidentType.text = historyModel.accidenttypename
            accidentTimeLabel.text = historyModel.starttime
            accidentAddress.text = historyModel.accidentaddress
            processingLabel.text = historyModel.flowname
            
            carPhotoImage.sd_setImageWithURL(NSURL(string: "http://7xttl7.com2.z0.glb.qiniucdn.com/\(historyModel.photosrc)"), placeholderImage: UIImage(named: "ic_launcher"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.lightGrayColor()
//        carPhotoImage.contentMode = UIViewContentMode.ScaleAspectFill
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
