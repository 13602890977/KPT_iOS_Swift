//
//  DetailPhotoScrollViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/7/7.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class DetailPhotoScrollViewController: UIViewController,ZoomImageViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        
        // Do any additional setup after loading the view.
    }

    private func setView() {
//       self.view.addSubview(self.mainCollection)
        self.view.addSubview(self.mainScroller)
        self.mainScroller.contentSize = CGSize(width: SCRW * CGFloat(photoArr.count), height: SCRH - 40)
        for var i = 0 ;i < photoArr.count; i++ {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCRW, height: SCRH - 40))
            imageView.sd_setImageWithURL(NSURL(string: QinniuUrl +  (photoArr[i] as! String)))
            let zoomImageScr = ZoomImageView(frame:CGRect(x: SCRW * CGFloat(i), y: 0, width: SCRW, height: SCRH - 40), imageView: imageView)
            zoomImageScr.imageDelegate = self
            self.mainScroller.addSubview(zoomImageScr)
        }
        self.view.addSubview(self.footLabel)
        footLabel.text = "1/\(photoArr.count)"
        
        
    }
    func zoomImageDismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func moving(isMoving: Bool) {
        
    }
    private lazy var mainCollection : UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsetsMake(5,0,5,0)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 20, width: SCRW, height: SCRH - 40), collectionViewLayout: layout)
        collectionView.backgroundColor = MainColor
        collectionView.pagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.
        
        collectionView.registerClass(DetailPhotoCell.classForCoder(), forCellWithReuseIdentifier: "detailsPhotoCell")
        return collectionView
    }()
    private lazy var mainScroller : UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 20, width: SCRW, height: SCRH - 40))
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        
        return scrollView
    }()
    private lazy var footLabel :UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: SCRH - 20, width: SCRW, height: 20))
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(15)
        return label
    }()
    lazy var photoArr : NSMutableArray = NSMutableArray()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailPhotoScrollViewController : UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate,UIScrollViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArr.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier = "detailsPhotoCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as? DetailPhotoCell
        cell?.photoStr = photoArr[indexPath.row] as! String
        
        return cell!
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: SCRW  , height: SCRH - 40)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell!.backgroundColor = MainColor
        
    }
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell!.backgroundColor = UIColor.whiteColor()
    }
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.footLabel.text = "\(Int(scrollView.contentOffset.x / SCRW + 1 + 0.5))/\(photoArr.count)"
    }
}