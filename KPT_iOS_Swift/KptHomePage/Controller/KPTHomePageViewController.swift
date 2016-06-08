//
//  KPTHomePageViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/19.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit


class KPTHomePageViewController: UIViewController {
    ///地图View
    var mapView : MAMapView!
    ///地图搜索
    var mapSearch : AMapSearchAPI?
    ///逆地理编码返回
    var rego : AMapReGeocodeSearchRequest?
    var annotation:MAPointAnnotation!
    ///系统定位管理类
    var locationManager : CLLocationManager?
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var showView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
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
    
     private func MapDisplayAndLocation() {
        //将定位条设置为圆角
        addressView.layer.masksToBounds = true
        addressView.layer.cornerRadius = 10
        
        openLocationService()
        
        MAMapServices.sharedServices().apiKey = APIKEY
        AMapNaviServices.sharedServices().apiKey = APIKEY//代替下面的方法
//        AMapSearchServices.sharedServices().apiKey = APIKey
        
        mapView = MAMapView(frame:self.view.bounds)
        
        mapView.delegate = self
        mapView.showsUserLocation = true //开启定位
        mapView.showsCompass = false //不显示罗盘
        mapView.showsScale = false //关闭比例尺
        //设置定位模式
        mapView.distanceFilter = 10.0
        mapView.userTrackingMode = MAUserTrackingModeFollow
        mapView.setZoomLevel(16.1, animated: true)
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        
        
        //搜索服务
        AMapSearchServices.sharedServices().apiKey = APIKEY
        mapSearch = AMapSearchAPI()
        mapSearch?.delegate = self
        
        rego = AMapReGeocodeSearchRequest()//逆地址编码
        showView.frame.origin.x = SCRW
        
        //发起地址编码
//        let geo = AMapGeocodeSearchRequest()
//        geo.address = addressLabel.text
//        mapSearch?.AMapGeocodeSearch(geo)
        
        //设置底下的事故处理label
        setButtomLabel()
        
        //创建右侧弹出视图
        setRightViewThirdBtn()
    }
    private func openLocationService() {
        locationManager = CLLocationManager()
        if !CLLocationManager.locationServicesEnabled() {
            print("定位服务未开启，请设置打开")
        }
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {///如果没有开启定位服务，请求开启
            locationManager?.requestWhenInUseAuthorization()
        }else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            
        }
        
    }
    private func setRightViewThirdBtn() {
        let maskPath = UIBezierPath(roundedRect: self.btnView.bounds, byRoundingCorners: [UIRectCorner.BottomLeft , UIRectCorner.TopLeft], cornerRadii: CGSize(width: 25, height: 25))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = self.btnView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.btnView.layer.mask = maskLayer;
        
        let maskPath_show = UIBezierPath(roundedRect: self.showView.bounds, byRoundingCorners: [UIRectCorner.BottomLeft , UIRectCorner.TopLeft], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer_show = CAShapeLayer()
        maskLayer_show.frame = self.showView.bounds;
        maskLayer_show.path = maskPath_show.CGPath;
        self.showView.layer.mask = maskLayer_show;
    }
    
    private func setButtomLabel() {
        let label = UILabel(frame: CGRect(x: 0, y: buttomView.frame.size.height - 35, width: 80, height: 30))
        var point = label.center
        point.x = self.view.frame.size.width * 0.5
        label.center = point
        label.textAlignment = NSTextAlignment.Center
        label.text = "事故处理"
        label.textColor = MainColor
        label.font = UIFont(name: "Arial-BoldItalicMT", size: 20)
        buttomView.addSubview(label)
    }
    
    //责任认定按钮点击事件
    @IBAction func cognizanceBtnClick(sender: AnyObject) {
        print("责任认定")
    }
    //在线定损按钮点击事件
    @IBAction func insuranceBtnClick(sender: AnyObject) {
        print("在线定损")
    }
    //一键报案按钮点击事件
    @IBAction func reportBtnClick(sender: AnyObject) {
        print("一键报案")
    }
    //定位图标上的button点击事件
    @IBAction func addressBtnClick(sender: AnyObject) {
        print("打开全国城市列表")
    }
    //展开菜单按钮点击事件
    @IBAction func BtnViewClick(sender: AnyObject) {
        
        UIView.animateWithDuration(0.25) { () -> Void in
            let transform = CGAffineTransformMakeTranslation(105, 0)//向右移动105
            self.btnView.transform = transform
            
            let showViewTransform = CGAffineTransformMakeTranslation(-200, 0)//向左移动200
            self.showView.transform = showViewTransform
        }
    }
    //隐藏菜单按钮点击事件
    @IBAction func showBtnClick(sender: AnyObject) {
        UIView.animateWithDuration(0.25) { () -> Void in
            self.btnView.transform = CGAffineTransformIdentity
            self.showView.transform = CGAffineTransformIdentity
        }
    }
   
    //懒加载控件 （private私有)
    private lazy var acctionBtn:UIButton = {
       let btn = UIButton(type: UIButtonType.Custom)
        btn.frame = CGRect(x: 0, y: self.view.frame.size.height - 200, width: 91, height: 91)
        var btnCenter = btn.center
        btnCenter.x = self.buttomView.bounds.size.width * 0.5
        btn.center = btnCenter
        btn.setImage(UIImage(named: "圆"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "actionBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    func actionBtnClick(btn:UIButton) {
        let nav:UINavigationController!
        if NSUserDefaults.standardUserDefaults().objectForKey("userInfoLoginData") == nil {
            nav = UINavigationController(rootViewController: Kpt_LoginViewController(nibName: "Kpt_LoginViewController", bundle: nil))
        }else {
            nav = UINavigationController(rootViewController: PersonalCenterViewController())
        }
        //信息界面出现的动画方式
        nav.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        let vc = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        vc!.presentViewController(nav, animated: true, completion: nil)
    }
    private lazy var buttomView:UIView = {
       let imageView = UIImageView()
        imageView.userInteractionEnabled = false
        let imageViewW = SCRW;
        let imageViewH:CGFloat = 135;
        imageView.frame = CGRect(x: 0, y: -(imageViewH * 0.5), width: imageViewW, height: imageViewH);
        imageView.image = UIImage(named: "image")
        return imageView
    }()
    private lazy var contentView:UIView = {
        let buttomViewW = SCRW;
        let buttomViewH:CGFloat = 80;
        let buttomViewX:CGFloat = 0;
        let buttomViewY = self.view.bounds.size.height - 135;
    
        let content = UIView(frame:CGRect(x:buttomViewX,y:buttomViewY,width:  buttomViewW,height:  buttomViewH));
        return content;
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        mapView.showsUserLocation = true
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        mapView.showsUserLocation = false
    }
}

extension KPTHomePageViewController : AMapSearchDelegate,MAMapViewDelegate{
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        if updatingLocation  {
            //取出当前位置
            print("latitude == \(userLocation.coordinate.latitude) longitude == \(userLocation.coordinate.longitude)")
            
            rego!.location = AMapGeoPoint.locationWithLatitude(CGFloat(userLocation.coordinate.latitude), longitude: CGFloat(userLocation.coordinate.longitude))
            rego!.radius = 1000
            rego!.requireExtension = true
            //发起逆地理编码
            mapSearch!.AMapReGoecodeSearch(rego)
        }
    }
    func mapView(mapView: MAMapView!, didLongPressedAtCoordinate coordinate: CLLocationCoordinate2D) {
        searchReGeocodeWithCoordinate(coordinate)
    }
    func mapView(mapView: MAMapView!, viewForAnnotation annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKindOfClass(MAPointAnnotation) {
            let annotationIdentifier = "invertGeoIdentifier"
            var poiAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) as? MAPinAnnotationView
            if poiAnnotationView == nil {
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            poiAnnotationView!.pinColor = MAPinAnnotationColor.Green
            poiAnnotationView?.animatesDrop = true
            poiAnnotationView?.canShowCallout = true
            
            return poiAnnotationView
        }
        return nil
    }
    
    func AMapSearchRequest(request: AnyObject!, didFailWithError error: NSError!) {
        print("request :\(request), error: \(error)")
    }
    
    func searchReGeocodeWithCoordinate(coordinate: CLLocationCoordinate2D!) {
        let regeo: AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
        regeo.location = AMapGeoPoint.locationWithLatitude(CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        print("regeo :\(regeo)")
        self.mapSearch!.AMapReGoecodeSearch(regeo)
    }
    
    func onGeocodeSearchDone(request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        if response.geocodes.count == 0 {
            return
        }
        let strCount:String = "\(response.count)"
        var strGeocodes = ""
        for tip in response.geocodes  {
            strGeocodes = "\(strGeocodes)\ngeocode:\(tip.description)"
        }
        let result = "\(strCount) \n \(strGeocodes)"
        print(result)
    }
    //逆地址编码回调
    func onReGeocodeSearchDone(request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        print("代理")
        print("request :\(request)")
        print("response :\(response)")
        
        if (response.regeocode != nil) {
            let coordinate = CLLocationCoordinate2DMake(Double(request.location.latitude), Double(request.location.longitude))
            if addressLabel.text == response.regeocode.formattedAddress {
                return
            }
            //设置大头针
            if annotation == nil {
                annotation = MAPointAnnotation()
                
                annotation.coordinate = coordinate
//                annotation.title = response.regeocode.addressComponent.province + response.regeocode.addressComponent.city
                annotation.subtitle = response.regeocode.formattedAddress
                mapView!.addAnnotation(annotation)
            }
            
            
            let overlay = MACircle(centerCoordinate: coordinate, radius: 100.0)
            mapView!.addOverlay(overlay)
            
            var str = annotation.subtitle as NSString
            let range = str.rangeOfString("市")
            if range.length > 0 {
               str = str.substringFromIndex(range.location + 1)
            }
            cityLabel.text = response.regeocode.addressComponent.city
            
            addressLabel.text = str as String
        }
    }
}