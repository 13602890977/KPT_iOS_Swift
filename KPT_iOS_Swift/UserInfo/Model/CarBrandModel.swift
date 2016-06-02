//
//  CarBrandModel.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/31.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class CarBrandModel: NSObject {

    var brandid:String!
    
    var brandinitial:String!
    
    var brandlogo:String!
    
    var brandname:String!
    
    //可以使用自定义的方法初始化模型，但是比较繁琐
    init(brandid: String, brandinitial: String, brandlogo: String, brandname: String) {
        super.init()
        self.brandid = brandid
        self.brandinitial = brandinitial
        self.brandlogo = brandlogo
        self.brandname = brandname
    }
    override init() {
        super.init()
    }
    //巧用 description 打印对象时，输出对象的属性 
    override var description :String {
        return "brandid: \(brandid)" +
            "brandinitial: \(brandinitial)" +
            "brandlogo: \(brandlogo)" +
            "brandname: \(brandname)"
    }
}

///车系model
class CarSeriesModel: NSObject {
    var seriesid:String!
    var seriesname:String!
    
    override var description :String {
        return "seriesid: \(seriesid)" +
            "seriesname: \(seriesname)"
    }
}
//车型年限model
class CarModelModel:NSObject {
    var modelid:String!
    
    var modelname:String!
    
    var prcie:String!
    
    var myear:String!
}
