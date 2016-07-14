//
//  DetailPhotoCell.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/7/8.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class DetailPhotoCell: UICollectionViewCell,ZoomImageViewDelegate {

    var photoStr : String! {
        didSet {
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCRW, height: SCRH - 40))
             imageView.sd_setImageWithURL(NSURL(string: QinniuUrl +  photoStr))
            let zoomImageScr = ZoomImageView(frame:CGRect(x: 0, y: 0, width: SCRW, height: SCRH - 40), imageView: imageView)
            zoomImageScr.imageDelegate = self
            
            self.contentView.addSubview(zoomImageScr)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
  
    
    func moving(isMoving: Bool) {
        
    }
    func zoomImageDismiss() {
        
    }
}
