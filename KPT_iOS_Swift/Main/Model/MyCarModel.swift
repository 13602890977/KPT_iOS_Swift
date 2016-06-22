//
//  MyCarModel.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/13.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class MyCarModel: NSObject {
    ///标记是否被选中了(默认为false)
    var isSelected : Bool = false
    ///初登日期
    var initialdate: String!
    ///图片url
    var registration: String!
    ///车牌型号id
    var vehiclemodelsid: String!
    ///车辆id
    var carid: String!
    ///车架号
    var vinno: String!
    ///发证日期
    var creationdate: String!
    ///用户id
    var userid: String!
    ///厂牌型号
    var brandno: String!
    ///车主姓名
    var renewed: String!
    ///车辆类型
    var cartype: String!
    ///车主住址
    var address: String!
    ///车牌号
    var carno: String!
    ///车牌型号
    var vehiclemodels: String!
    ///商业投保保险公司
    var insurecompany: String!
    ///商业保险金额
    var insuremoney: String!
    ///发动机号
    var engineno: String!
    ///出险次数
    var beindangertime: String!
}
