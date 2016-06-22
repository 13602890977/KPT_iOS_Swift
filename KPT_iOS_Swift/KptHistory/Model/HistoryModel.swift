//
//  HistoryModel.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/15.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class HistoryModel: NSObject {
    ///事故地点
    var accidentaddress : String!
    ///事故类型代号
    var accidenttype : String!
    ///事故类型名称
    var accidenttypename : String!
    ///事故车辆
    var partiescarno : String!
    ///事故处理方法ID
    var flowid : String!
    ///事故处理方法名称
    var flowname : String!
    ///事故处理阶段
    var flowstart : String!
    ///照片
    var photosrc : String!
    ///事故时间
    var starttime : String!
    ///任务id
    var taskid : String!
}
