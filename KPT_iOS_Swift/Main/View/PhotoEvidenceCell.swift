//
//  PhotoEvidenceCell.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/15.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoEvidenceCell: UICollectionViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoLabel: UILabel!
    var photoName: String! {
        didSet {
            if photoName.hasPrefix("http") {
                photoImage.sd_setImageWithURL(NSURL(string:photoName))
                photoImage.sd_setImageWithURL(NSURL(string:photoName), placeholderImage: UIImage(named: ""), options: SDWebImageOptions.ProgressiveDownload, progress: { (receivedSize, expectedSize) -> Void in
                    print(receivedSize)
                    print(expectedSize)
                    }, completed: { (image, error, cacheType, url) -> Void in
                        
                })
                photoImage.contentMode = UIViewContentMode.ScaleToFill
                
            }else {
                photoImage.image = UIImage(named: photoName)
                photoImage.contentMode = UIViewContentMode.Center
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImage.layer.cornerRadius = 0.5
        // Initialization code
    }

}
