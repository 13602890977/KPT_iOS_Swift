//
//  PhotoEvidenceViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/15.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class PhotoEvidenceViewController: UIViewController {

   
    @IBOutlet weak var mainCollection: UICollectionView!
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var lockBtn: UIButton!
    
    var accidentType : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "拍照取证"
        self.mainCollection.backgroundColor = UIColor.whiteColor()
            
        mainCollection.registerNib(UINib(nibName: "PhotoEvidenceCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        print(self.lockBtn)
//        self.collectionHeight.constant = CGFloat(Int(SCRH) - 124 - (180 * 2))
//        self.mainCollection.updateConstraintsIfNeeded()
        // Do any additional setup after loading the view.
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        if indexPath.row == CarPhotoArr.count - 1 {
            CarPhotoArr.addObject("矢量智能对象")
            self.mainCollection.reloadData()
        }
        
    }
    private lazy var CarPhotoArr : NSMutableArray = {
        var arr = NSMutableArray()
        if self.accidentType == "twoCar" {
            arr = ["前45","后45","特写","A全景","B全景","矢量智能对象"]
        }else {
            arr = ["前45","后45","特写","矢量智能对象"]
        }
        return arr
    }()
    private lazy var CarPhotoStrArr : [String] = {
        var arr = [String]()
        if self.accidentType == "twoCar" {
            arr = ["现场正面45度全景照","现场背面45度全景照","碰撞部位特写","我方车辆全景","对方车辆全景"]
        }else {
            arr = ["侧前方全景","侧后方全景","碰撞部位特写"]
        }
        return arr
        }()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //查看照片示例
    @IBAction func lockBtnClick(sender: AnyObject) {
    }
    

}

extension PhotoEvidenceViewController :UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CarPhotoArr.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionIdentifier = "cell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionIdentifier, forIndexPath: indexPath) as! PhotoEvidenceCell
        
        cell.photoImage.image = UIImage(named: CarPhotoArr[indexPath.row] as! String)
        cell.photoImage.contentMode = UIViewContentMode.Center
        if indexPath.row < CarPhotoStrArr.count {
            cell.photoLabel.text = CarPhotoStrArr[indexPath.row]
        }else {
            cell.photoLabel.text = "其它照片"
        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: SCRW * 0.3 , height: SCRW * 0.3 + 40)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
}