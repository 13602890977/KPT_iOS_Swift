//
//  DamageResultsViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/25.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class DamageResultsViewController: UIViewController,Kpt_NextBtnViewDelegate {

    var damageDataArr : NSMutableArray!
    ///用于标记是否点击收起
    private var isExpand : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "定损结果"
        
        self.view.addSubview(self.tableView)
        // Do any additional setup after loading the view.
    }
    func nextBtnClick(nextBtn: Kpt_NextBtnView) {
        self.navigationController?.pushViewController(RepairTableViewController(), animated: true)
    }

    private lazy var tableView : UITableView = {
        let view = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    private lazy var imageButton : UIButton = UIButton(type: UIButtonType.Custom)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
extension DamageResultsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpand {
            return 0
        }
        return (self.damageDataArr.firstObject as! DamageModel).parts.count + 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let damageCellIdentifier = "damageCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(damageCellIdentifier) as? DamageResultCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("DamageResultCell", owner: nil, options: nil).last as? DamageResultCell
        }
        if indexPath.row == 0 {
            
        }else if indexPath.row == (self.damageDataArr.firstObject as! DamageModel).parts.count + 1 {
            cell?.totalLabel.hidden = false
            cell?.positionLabel.hidden = true
            cell?.degreeLabel.hidden = true
            cell?.costLabel.hidden = true
            cell?.totalLabel?.text = "参考费用：\((self.damageDataArr.firstObject as! DamageModel).repairsumprice)元"
            
        }else {
            cell?.positionDict = (self.damageDataArr.firstObject as! DamageModel).parts[indexPath.row - 1] as! NSMutableDictionary
        }
        return cell!
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel(frame: CGRect(x: 15, y: 10, width: 100, height: 20))
        label.text = (self.damageDataArr.firstObject as! DamageModel).partiescarno
        view.addSubview(label)
        
        imageButton.frame = CGRect(x: SCRW - 15 - 20, y: 10, width: 20, height: 20)
        imageButton.setImage(UIImage(named: "round_w"), forState: UIControlState.Normal)
        imageButton.setImage(UIImage(named: "round_y"), forState: UIControlState.Selected)
        imageButton.addTarget(self, action: "imageButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        let lineImage = UIImageView(frame: CGRect(x: 0, y: 40 - 1, width: SCRW, height: 1))
        lineImage.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(lineImage)
        view.addSubview(imageButton)
        return view
    }
    func imageButtonClick() {
        imageButton.selected = !imageButton.selected
        isExpand = !isExpand
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40) + 60
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let cellMainHeight:CGFloat = IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: SCRW, height: cellMainHeight + 60))
        backView.backgroundColor = UIColor.RGBA(218, g: 218, b: 218)
        let view = Kpt_NextBtnView(frame: CGRect(x: 0, y: 20, width: SCRW, height: cellMainHeight + 40))
        view.delegate = self
        view.btnText = "自行维修"
        
        view.backgroundColor = UIColor.whiteColor()
        backView.addSubview(view)
        return backView

    }
}
