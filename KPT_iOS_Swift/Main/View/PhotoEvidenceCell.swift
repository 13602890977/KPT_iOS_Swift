//
//  PhotoEvidenceCell.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/15.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class PhotoEvidenceCell: UICollectionViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImage.layer.cornerRadius = 0.5
        // Initialization code
    }

}
