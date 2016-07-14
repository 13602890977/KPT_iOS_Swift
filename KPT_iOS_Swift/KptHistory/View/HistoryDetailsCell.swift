//
//  HistoryDetailsCell.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/17.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class HistoryDetailsCell: UITableViewCell {
    ///事故类型名称
    @IBOutlet weak var accidentTypeName: UILabel!
    ///事故时间
    @IBOutlet weak var accidentTimeLabel: UILabel!
    ///事故车辆 一
    @IBOutlet weak var accidentCarOneLabel: UILabel!
    ///事故车辆 二
    @IBOutlet weak var accudentCarTwoLabel: UILabel!
    ///对一车的处理操作结果
    @IBOutlet weak var treatmentTypeOneLabel: UILabel!
    ///对二车的处理操作结果
    @IBOutlet weak var treatmentTypeTwoLabel: UILabel!
    ///cell左边的竖线image
    @IBOutlet weak var leftLineImage: UIImageView!
    @IBOutlet weak var leftLineConstraint: NSLayoutConstraint!
    ///cell左边的圆点image
    @IBOutlet weak var leftRoundImage: UIImageView!
    ///继续处理按钮(默认隐藏)
    @IBOutlet weak var continueBtn: UIButton!
    ///cell下方的横线
    @IBOutlet weak var buttomLineImage: UIImageView!
    
    ///接收传入的数据
    var data : AnyObject? {
        didSet {
            if data as? String == "reportdata" || data as? reportdataModel != nil{
//                leftRoundImage.image = UIImage(named: "round_w")
                accidentTypeName.text = "一键报案"
                accidentTimeLabel.hidden = true
                accidentCarOneLabel.hidden = true
                accudentCarTwoLabel.hidden = true
                treatmentTypeOneLabel.hidden = true
                treatmentTypeTwoLabel.hidden = true
                if data as? String == "reportdata" {
                    continueBtn.hidden = false
                    leftRoundImage.image = UIImage(named: "round_y")
                }else {
                    self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                    
                }
            }else if data as? String == "lossdata" || data as? lossdataModel != nil  {
                if data as? String == "lossdata" {//在线定损未完成
                    accidentTimeLabel.hidden = true
                    accidentCarOneLabel.hidden = true
                    treatmentTypeOneLabel.hidden = true
                    accudentCarTwoLabel.hidden = true
                    treatmentTypeTwoLabel.hidden = true
                    continueBtn.hidden = false
                    leftRoundImage.image = UIImage(named: "round_y")
                }else {
                    let loss = data as! lossdataModel
                    accidentTypeName.text = "在线定损"
                    accidentTimeLabel.text = loss.createdate
                    print(loss.lossdetail?.count)
                    if loss.lossdetail?.count > 0 {
                        self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                        
                        let dict1 = loss.lossdetail![0]
                        let dict2 = loss.lossdetail![1]
                        if let data = dict1 as? NSDictionary {
                            accidentCarOneLabel.text = data.objectForKey("carno") as? String
                            
                            treatmentTypeOneLabel.text = "维修费" + "\(data.objectForKey("repairsumprice") as! String)" + "元"
                            if let data2 = dict2 as? NSDictionary {
                                accudentCarTwoLabel.text = data2.objectForKey("carno") as? String
                                
                                treatmentTypeTwoLabel.text = "维修费" + "\(data2.objectForKey("repairsumprice") as! String)" + "元"
                            }else {
                                accudentCarTwoLabel.hidden = true
                                treatmentTypeTwoLabel.hidden = true
                            }
                        }else {
                            if let data2 = dict2 as? NSDictionary {
                                accidentCarOneLabel.text = data2.objectForKey("carno") as? String
                                
                                treatmentTypeOneLabel.text = "维修费" + "\(data2.objectForKey("repairsumprice") as! String)" + "元"
                            }
                            accudentCarTwoLabel.hidden = true
                            treatmentTypeTwoLabel.hidden = true
                        }
                    }else {
                        accidentCarOneLabel.hidden = true
                        treatmentTypeOneLabel.hidden = true
                        accudentCarTwoLabel.hidden = true
                        treatmentTypeTwoLabel.hidden = true
                        continueBtn.hidden = false
                        leftRoundImage.image = UIImage(named: "round_y")
                    }
                }
            }else if data as? String == "dutydata" || data as? dutydataModel != nil {//dutydata
                accidentTypeName.text = "在线定责"
                if data as? String == "dutydata" {//在线定责未完成
                    accidentTimeLabel.hidden = true
                    accidentCarOneLabel.hidden = true
                    treatmentTypeOneLabel.hidden = true
                    accudentCarTwoLabel.hidden = true
                    treatmentTypeTwoLabel.hidden = true
                    continueBtn.hidden = false
                    leftRoundImage.image = UIImage(named: "round_y")
                }else {
                    let duty = data as! dutydataModel
                    
                    accidentTimeLabel.text = duty.createdate
                    print(duty.dutydetail?.count)
                    if duty.dutydetail?.count > 0 {
                        self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                        
                        let dict1 = duty.dutydetail![0]
                        let dict2 = duty.dutydetail![1]
                        if let data = dict1 as? NSDictionary {
                            accidentCarOneLabel.text = data.objectForKey("carno") as? String
                            
                            treatmentTypeOneLabel.text = "\(data.objectForKey("dutyname") as! String) " + "\(data.objectForKey("dutyratio") as! String)" + "%责任"
                            
                            if let data2 = dict2 as? NSDictionary {
                                accudentCarTwoLabel.text = data2.objectForKey("carno") as? String
                                
                                treatmentTypeTwoLabel.text = "\(data2.objectForKey("dutyname") as! String) " + "\(data2.objectForKey("dutyratio") as! String)" + "%责任"
                            }else {
                                accudentCarTwoLabel.hidden = true
                                treatmentTypeTwoLabel.hidden = true
                            }
                        }else {
                            if let data2 = dict2 as? NSDictionary {
                                accidentCarOneLabel.text = data2.objectForKey("carno") as? String
                                
                                treatmentTypeOneLabel.text = "\(data2.objectForKey("dutyname") as! String) " + "\(data2.objectForKey("dutyratio") as! String)" + "%责任"
                            }
                            accudentCarTwoLabel.hidden = true
                            treatmentTypeTwoLabel.hidden = true
                        }
                    }else {
                        accidentCarOneLabel.hidden = true
                        treatmentTypeOneLabel.hidden = true
                        accudentCarTwoLabel.hidden = true
                        treatmentTypeTwoLabel.hidden = true
                    }

                }
                
            }else if let photo = data as? photodataModel {//拍照取证肯定是最后一个，并且一定存在
                accidentTypeName.text = "拍照取证"
                accidentTimeLabel.text = photo.createdate
                accidentCarOneLabel.hidden = true
                treatmentTypeOneLabel.hidden = true
                accudentCarTwoLabel.hidden = true
                treatmentTypeTwoLabel.hidden = true
                self.contentView.addSubview(self.collectionView)
                buttomLineImage.hidden = true
            }
        }
    }
    ///接收cell的行数
    var indexPathRow : Int! {
        didSet{
            if indexPathRow != 0 {
                leftLineConstraint.constant = 0.0
                leftLineImage.updateConstraintsIfNeeded()
            }
        }
    }

    private lazy var collectionView : UICollectionView = {
        var layout = UICollectionViewFlowLayout()

        layout.sectionInset = UIEdgeInsetsMake(5,5,5,5)
        
        var viewHeight = self.frame.height
        if let photo = self.data as? photodataModel {
            
            let phtotRow = (photo.photodata?.count)! / 2
            let photoSection = (photo.photodata?.count)! % 2
            
            viewHeight = CGFloat(phtotRow + photoSection) * CGFloat(SCRW * 0.3 + 30) + (10 * CGFloat(phtotRow))
        }
        let view = UICollectionView(frame:CGRect(x: 30, y: 40, width: SCRW - 50, height: viewHeight), collectionViewLayout: layout)
        view.scrollEnabled = false
        view.alwaysBounceVertical = true
        
        view.backgroundColor = UIColor.whiteColor()
        view.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "photoCell")
        
        view.delegate = self
        view.dataSource = self
        return view
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    ///点击继续处理按钮
    @IBAction func continueButtonClick(sender: AnyObject) {
        print(accidentTypeName.text)
        NSNotificationCenter.defaultCenter().postNotificationName("KPT_HistoryDetailsCell", object: nil, userInfo: [accidentTypeName.text!:"继续处理"])
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension HistoryDetailsCell : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let photo = data as? photodataModel {
            accidentTimeLabel.text = photo.createdate
            print("数量是\(photo.photodata?.count)")
            return (photo.photodata?.count)! > 0 ? (photo.photodata?.count)! : 0
        }
        return 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionIdentifier = "photoCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionIdentifier, forIndexPath: indexPath)
        if let photo = data as? photodataModel {
            accidentTimeLabel.text = photo.createdate
            let uiimage = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            
            uiimage.sd_setImageWithURL(NSURL(string:QinniuUrl + "\(photo.photodata![indexPath.row])"), placeholderImage: UIImage(named: "Kpt_login_title"))
            uiimage.contentMode = UIViewContentMode.ScaleAspectFill
            uiimage.clipsToBounds = true
            
            cell.contentView.addSubview(uiimage)
        }
//        cell.backgroundColor = UIColor.orangeColor()
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName("KPT_DetailsPhotoCell", object: nil)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: SCRW * 0.3 + 20 , height: SCRW * 0.3 + 20)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
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
}
