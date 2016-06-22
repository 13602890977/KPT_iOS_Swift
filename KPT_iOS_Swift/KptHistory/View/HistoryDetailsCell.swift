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
            if data as? reportdataModel != nil{
//                leftRoundImage.image = UIImage(named: "round_w")
                accidentTypeName.text = "一键报案"
                accidentTimeLabel.hidden = true
                accidentCarOneLabel.hidden = true
                accudentCarTwoLabel.hidden = true
                treatmentTypeOneLabel.hidden = true
                treatmentTypeTwoLabel.hidden = true
            }else if let loss = data as? lossdataModel {
                accidentTypeName.text = "在线定损"
                accidentTimeLabel.text = loss.createdate
                print(loss.lossdetail?.count)
                if loss.lossdetail?.count > 0 {
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
                }
            }else if let duty = data as? dutydataModel {
                accidentTypeName.text = "在线定责"
                accidentTimeLabel.text = duty.createdate
                print(duty.dutydetail?.count)
                if duty.dutydetail?.count > 0 {
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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
