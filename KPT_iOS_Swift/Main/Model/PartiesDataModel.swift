//
//  PartiesDataModel.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/29.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class PartiesDataModel: NSObject {
    class var sharePartiesData : PartiesDataModel {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var partiesData : PartiesDataModel? = nil
        }
        dispatch_once(&Static.onceToken) { () -> Void in
            Static.partiesData = PartiesDataModel()
        }
        return Static.partiesData!
    }
    
}
