//
//  HistoryDetailModel.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/17.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
@objc class HistoryDetailModel: NSObject {
    
    var taskid: String!
    ///事故照片
    var photodata: photodataModel?
    ///事故分责
    var dutydata: dutydataModel?
    ///任务id和详情
    var reportdata: String?
    ///事故车辆详情
    var partiesdata: [partiesdataModel]?
    ///维修费用(定损)
    var lossdata: lossdataModel?
}

@objc class photodataModel :NSObject {
    var flowid : String!
    var createdate : String! //流程创建时间
    ///图片数组
    var photodata : NSArray?
    var responsibilitydata : NSArray?
}
@objc class reportdataModel :NSObject {
    var flowid:NSDictionary!
}
@objc class partiesdataModel :NSObject {
    var partiesmark : String!
    var insurancecode : String!
    var insurancename : String!
    var licenseno : String!
    var mobile : String!
    var partiescarno : String!
    var partiesname : String!
    var vehicleid : String!
    var vehiclename : String!
}
@objc class dutydataModel :NSObject {
    var flowid :String!
    var createdate:String? //流程创建时间
    var fixduty:String!//1代表双方协定 2代表交警定责
    var dutystatus:String!//0代表责任未完成 1代表责任已完成
    var dutydetail:NSArray?
}

@objc class lossdataModel: NSObject {
    
    var flowid:String!
    var createdate:String?//流程创建时间
    var lossdetail : NSArray?
}