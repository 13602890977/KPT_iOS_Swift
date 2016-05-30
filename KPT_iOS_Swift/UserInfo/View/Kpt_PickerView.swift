//
//  Kpt_PickerView.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/26.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

enum pickerType: Int {
    case DatePick = 0
    case OtherType = 1
}
///定义一个闭包
typealias sendValuePicker = (str:String) -> Void

class Kpt_PickerView: UIView ,UIPickerViewDelegate,UIPickerViewDataSource{

    var pick : UIPickerView?
    var datePick:UIDatePicker?
    var otherPicker:UIPickerView?
    //声明并持有闭包
    var myBlock:sendValuePicker?
    
    ///保存选择的数据
    var pickViewSelectValue:String?
    ///保存传入的数据数组
    var pickArr:[String]? {
        didSet {
            pickViewSelectValue = pickArr?.first
        }
    }
   
    ///保存传入的数据类型
    var pickType:pickerType?
    
    class func creatPickerWithFrame(frame:CGRect,type:pickerType) -> Kpt_PickerView {
        let pickView = Kpt_PickerView(frame: frame)
        pickView.pickType = type
        
        if type == pickerType.DatePick {
            pickView.datePick = UIDatePicker(frame: CGRect(x: 0, y: 44, width: pickView.frame.size.width, height: pickView.frame.size.height))
            pickView.datePick?.locale = NSLocale(localeIdentifier: "zh-CN")
            pickView.datePick?.datePickerMode = UIDatePickerMode.Date
            pickView.addSubview(pickView.datePick!)
        }else {
            pickView.otherPicker = UIPickerView(frame: CGRect(x: 0, y: 44, width: pickView.frame.size.width, height: pickView.frame.size.height))
            pickView.otherPicker!.delegate = pickView
            pickView.otherPicker!.dataSource = pickView
            pickView.addSubview(pickView.otherPicker!)
            
        }
        return pickView
    }

    override init(frame: CGRect) {
       super.init(frame: frame)
        self.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(self.toolbar)
    }

    private lazy var toolbar:UIToolbar = {
       let tool = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 44))
        let cancelBtn = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelButtonClick:")
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let ensureBtn = UIBarButtonItem(title: "确定", style: UIBarButtonItemStyle.Plain, target: self, action: "ensureButtonClick:")
        tool.items = [cancelBtn,spaceBtn,ensureBtn]
        
        return tool
    }()
    
    func cancelButtonClick(sendr:AnyObject?) {
        self.removeFromSuperview()
    }
    func ensureButtonClick(sender:AnyObject?) {
        switch pickType! {
        case .DatePick:
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            self.myBlock!(str:dateFormatter.stringFromDate(datePick!.date))
            break
        case .OtherType:
            print(self.otherPicker)
            self.myBlock!(str: self.pickViewSelectValue!)
            break
        }
        self.removeFromSuperview()
    }
    ///用于闭包(相当于OC的block)传递返回值的方法
    func ensureButtonReturnDate(block:sendValuePicker?) {
        self.myBlock = block
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Kpt_PickerView {
    func numberOfComponentsInPickerView(pickerView:UIPickerView) -> NSInteger {
        return 1;
    }
    //返回有几行
    func pickerView(pickerView:UIPickerView , numberOfRowsInComponent component:NSInteger) ->NSInteger {
        return self.pickArr!.count;
    }
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.frame.size.width
    }
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, var reusingView view: UIView?) -> UIView {
        if view == nil {
            view = UIView()
        }
        let label = UILabel(frame: CGRect(x: 0, y: 5, width: self.frame.size.width, height: 20))
        label.text = self.pickArr![row]
        label.textAlignment = NSTextAlignment.Center
        view?.addSubview(label)
        
        return view!
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickViewSelectValue = pickArr![row]
    }
}