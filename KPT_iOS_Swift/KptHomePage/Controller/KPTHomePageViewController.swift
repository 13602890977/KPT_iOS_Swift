//
//  KPTHomePageViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/19.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit


class KPTHomePageViewController: UIViewController,AMapSearchDelegate,MAMapViewDelegate {
    ///地图View
    var mapView : MAMapView!
    ///地图搜索
    var mapSearch : AMapSearchAPI?
    ///逆地理编码返回
    var rego : AMapReGeocodeSearchRequest?
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var showView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.randomColor()
        view.addSubview(self.contentView)
        self.contentView.addSubview(self.buttomView)
        view.addSubview(self.acctionBtn)
//        acctionBtn.frame.origin.y = SCRH - 100
        //设置地图显示和定位
        MapDisplayAndLocation()
    }
    
     func MapDisplayAndLocation() {
        //将定位条设置为圆角
        addressView.layer.masksToBounds = true
        addressView.layer.cornerRadius = 10
        
        MAMapServices.sharedServices().apiKey = APIKEY
        AMapNaviServices.sharedServices().apiKey = APIKEY//代替下面的方法
//        AMapSearchServices.sharedServices().apiKey = APIKey
        
        mapView = MAMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        mapView.delegate = self
        mapView.showsUserLocation = true //开启定位
        mapView.showsCompass = false //不显示罗盘
        mapView.showsScale = false //关闭比例尺
        //设置定位模式
        mapView.userTrackingMode = MAUserTrackingModeFollow
        mapView.setZoomLevel(16.1, animated: true)
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        
        //搜索服务
//        AMapSearchAPI.
        mapSearch = AMapSearchAPI()
        rego = AMapReGeocodeSearchRequest()
//        showView.X = SCRW
        
    }
    //懒加载控件 （private私有)
    private lazy var acctionBtn:UIButton = {
       let btn = UIButton(type: UIButtonType.Custom)
        btn.frame = CGRect(x: 0, y: self.view.frame.size.height - 180, width: 91, height: 91)
        var btnCenter = btn.center
        btnCenter.x = self.buttomView.bounds.size.width * 0.5
        btn.center = btnCenter
        btn.setImage(UIImage(named: "圆"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "actionBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    func actionBtnClick(btn:UIButton) {
        print("弹出框")
    }
    private lazy var buttomView:UIView = {
       let imageView = UIImageView()
        imageView.userInteractionEnabled = false
        let imageViewW = SCRW;
        let imageViewH:CGFloat = 135;
        imageView.frame = CGRect(x: 0, y: -55, width: imageViewW, height: imageViewH);
        imageView.image = UIImage(named: "image")
        return imageView
    }()
    private lazy var contentView:UIView = {
        let buttomViewW = SCRW;
        let buttomViewH:CGFloat = 80;
        let buttomViewX:CGFloat = 0;
        let buttomViewY = self.view.bounds.size.height - 135;
    
        let content = UIView(frame:CGRect(x:buttomViewX,y:buttomViewY,width:  buttomViewW,height:  buttomViewH));        return content;
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
