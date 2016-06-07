//
//  ChangeInfoController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/3.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

typealias returnChangeText = (text:String) ->Void

class ChangeInfoController: UIViewController {
    //接收传入的cell
    var cell:UITableViewCell! 
    var changeText:returnChangeText!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let navigationBar = self.navigationController!.navigationBar;
        navigationBar.barTintColor = UIColor.blackColor()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(self.textField)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: "backOnAnInterface")
//        self.navigationItem.leftBarButtonItem
        
        self.title = cell.textLabel?.text
        if cell.detailTextLabel?.text?.hasPrefix("请输入") == true
        {
            self.textField.placeholder = cell.detailTextLabel?.text
        }else {
            self.textField.text = cell.detailTextLabel?.text
        }

        // Do any additional setup after loading the view.
    }

    func backOnAnInterface() {
        self.changeText(text: self.textField.text!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    func returnChangeBeforeText(block:returnChangeText) {
        self.changeText = block
    }
    
    private lazy var textField:UITextField = {
        let field = UITextField(frame: CGRect(x: 0, y: 20, width: SCRW, height: 46))
        field.borderStyle = UITextBorderStyle.None
        let label = UILabel(frame: CGRect(x: 0, y: 19, width: SCRW, height: 1))
        label.backgroundColor = UIColor.blackColor()
        self.view.addSubview(label)
        let label2 = UILabel(frame: CGRect(x: 0, y: 67, width: SCRW, height: 1))
        label2.backgroundColor = UIColor.blackColor()
        self.view.addSubview(label2)
        return field
    }()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
