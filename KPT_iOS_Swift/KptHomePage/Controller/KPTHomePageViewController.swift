//
//  KPTHomePageViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/19.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MBProgressHUD

class KPTHomePageViewController: UIViewController,UIGestureRecognizerDelegate {
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
        view.addSubview(self.buttomView)
//        self.contentView.addSubview(self.buttomView)
        buttomView.addSubview(self.acctionBtn)
//        acctionBtn.frame.origin.y = SCRH - 100
        
        self.hud.labelText = "定位中..."
        self.hud.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        self.hud.show(true)
        ///默认位置为广州
        NSUserDefaults.standardUserDefaults().setValue("23", forKey: "kpt_latlng")
        NSUserDefaults.standardUserDefaults().setValue("23", forKey: "Kpt_latitude")
        NSUserDefaults.standardUserDefaults().setValue("23:23", forKey: "Kpt_longitude")
        NSUserDefaults.standardUserDefaults().setValue("广州市天河区", forKey: "Kpt_address")
        
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
        if mapView == nil {
            mapView = MAMapView(frame:self.view.bounds)
            
            mapView.delegate = self
            mapView.showsUserLocation = true //开启定位
            mapView.showsCompass = false //不显示罗盘
            mapView.showsScale = false //关闭比例尺
        }
       
        //设置定位模式
        mapView.distanceFilter = 10.0
        mapView.userTrackingMode = MAUserTrackingModeFollow
        mapView.setZoomLevel(16.1, animated: true)
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        mapView.scrollEnabled = false
        
        let panG = UIPanGestureRecognizer(target: self, action: "panGestureClick:")
        panG.delegate = self
        mapView.addGestureRecognizer(panG)
       
        
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
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func panGestureClick(pan:UIPanGestureRecognizer) {
        let point = pan.translationInView(mapView)
        if point.x < 0 {
            mapView.scrollEnabled = false
        }else {
            mapView.scrollEnabled = true
        }
    }
    private func openLocationService() {
        locationManager = CLLocationManager()
        if !CLLocationManager.locationServicesEnabled() {
            print("定位服务未开启，请设置打开")
        }
//        if #available(iOS 8.0, *) {
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {///如果没有开启定位服务，请求开启
                locationManager?.requestWhenInUseAuthorization()
            }else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
                
            }
//        } else {
//            // Fallback on earlier versions
//        }
        
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
   
    func actionBtnClick(btn:UIButton) {
        let nav:UINavigationController!
        if NSUserDefaults.standardUserDefaults().objectForKey("userInfoLoginData") == nil {
            nav = UINavigationController(rootViewController: Kpt_LoginViewController(nibName: "Kpt_LoginViewController", bundle: nil))
        }else {
            nav = UINavigationController(rootViewController: AccidentViewController())
        }
        //信息界面出现的动画方式
        nav.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        let vc = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        vc!.presentViewController(nav, animated: true, completion: nil)
    }
    ///底部黑色图片View
    private lazy var buttomView:UIView = {
       let imageView = UIImageView()
        imageView.userInteractionEnabled = true
        let imageViewW = SCRW
        let imageViewH:CGFloat = SCRW / 375 * 135//根据图片比例计算view的高度,宽带不变(满屏)
        imageView.frame = CGRect(x: 0, y: self.view.frame.size.height - imageViewH - CGFloat(64), width: imageViewW, height: imageViewH)
        imageView.image = UIImage(named: "image")
        return imageView
    }()
    
    //懒加载控件 （private私有)
    ///底部圆button
    private lazy var acctionBtn:UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        
        let roundWidth = SCRW / 375 * 91
        btn.frame = CGRect(x: 0, y: 10, width: roundWidth, height: roundWidth)
        var btnCenter = btn.center
        btnCenter.x = SCRW * 0.5
        btn.center = btnCenter
        btn.setBackgroundImage(UIImage(named: "圆"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "actionBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    ///底部事故处理label
    private func setButtomLabel() {
        print(acctionBtn.frame.size.height + acctionBtn.frame.origin.y + 5)
        let label = UILabel(frame: CGRect(x: 0, y: acctionBtn.frame.size.height + acctionBtn.frame.origin.y , width: SCRW, height: buttomView.frame.height - acctionBtn.frame.height - 5))
//        var point = label.center
//        point.x = SCRW * 0.5
//        label.center = point
        label.textAlignment = NSTextAlignment.Center
        label.text = "事故处理"
        label.textColor = MainColor
        label.font = UIFont(name: "Arial-BoldItalicMT", size: 18)
        buttomView.addSubview(label)
    }

    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension KPTHomePageViewController : AMapSearchDelegate,MAMapViewDelegate{
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        if updatingLocation  {
            //取出当前位置
            print("latitude == \(userLocation.coordinate.latitude) longitude == \(userLocation.coordinate.longitude)")
            
            var latitudeStr = "\(userLocation.coordinate.latitude)" as NSString
            //将定位保存起来，方便取用
            let latitudeRange = latitudeStr.rangeOfString(".")
            if latitudeRange.length > 0 {
                latitudeStr = latitudeStr.substringToIndex(latitudeRange.location)
            }
            
            var longitudeStr = "\(userLocation.coordinate.longitude)" as NSString
            //将定位保存起来，方便取用
            let longitudeRange = longitudeStr.rangeOfString(".")
            if longitudeRange.length > 0 {
                longitudeStr = longitudeStr.substringToIndex(latitudeRange.location)
            }
            NSUserDefaults.standardUserDefaults().setValue("\(latitudeStr):\(longitudeStr)", forKey: "kpt_latlng")
            NSUserDefaults.standardUserDefaults().setValue(userLocation.coordinate.latitude, forKey: "Kpt_latitude")
            NSUserDefaults.standardUserDefaults().setValue(userLocation.coordinate.longitude, forKey: "Kpt_longitude")
            
            rego!.location = AMapGeoPoint.locationWithLatitude(CGFloat(userLocation.coordinate.latitude), longitude: CGFloat(userLocation.coordinate.longitude))
            rego!.radius = 1000
            rego!.requireExtension = true
            //发起逆地理编码
            mapSearch!.AMapReGoecodeSearch(rego)
        }
    }
//    func mapView(mapView: MAMapView!, didLongPressedAtCoordinate coordinate: CLLocationCoordinate2D) {
////        searchReGeocodeWithCoordinate(coordinate)
//    }
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
//            poiAnnotationView?.centerOffset = CGPointMake(0, -18)
            
            return poiAnnotationView
        }
        return nil
    }
    
    func mapView(mapView: MAMapView!, didFailToLocateUserWithError error: NSError!) {
        self.hud.labelText = "定位失败"
        self.hud.hide(true, afterDelay: 3.0)
    }
//    func AMapSearchRequest(request: AnyObject!, didFailWithError error: NSError!) {
//        print("request :\(request), error: \(error)")
//    }
//    
//    func searchReGeocodeWithCoordinate(coordinate: CLLocationCoordinate2D!) {
//        let regeo: AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
//        regeo.location = AMapGeoPoint.locationWithLatitude(CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
//        print("regeo :\(regeo)")
//        self.mapSearch!.AMapReGoecodeSearch(regeo)
//    }
    
//    func onGeocodeSearchDone(request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
//        if response.geocodes.count == 0 {
//            return
//        }
//        let strCount:String = "\(response.count)"
//        var strGeocodes = ""
//        for tip in response.geocodes  {
//            strGeocodes = "\(strGeocodes)\ngeocode:\(tip.description)"
//        }
//        let result = "\(strCount) \n \(strGeocodes)"
//        print(result)
//    }
    //逆地址编码回调
    func onReGeocodeSearchDone(request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        print("代理")
        print("request :\(request)")
        print("response :\(response)")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            ///将地址保存起来，方便取用
            var strP = response.regeocode.formattedAddress as NSString
            let rangeP = strP.rangeOfString("省")
            if rangeP.length > 0 && rangeP.location <= 3{
                strP = strP.substringFromIndex(rangeP.location + 1)
            }
            NSUserDefaults.standardUserDefaults().setValue(strP, forKey: "Kpt_address")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            print("\(NSThread.currentThread()) -- 地址\(strP)")
        }
        
        if (response.regeocode != nil) {
            let coordinate = CLLocationCoordinate2DMake(Double(request.location.latitude), Double(request.location.longitude))
            if addressLabel.text == response.regeocode.formattedAddress {
                return
            }
            //设置大头针
            if annotation == nil {
                annotation = MAPointAnnotation()
                
                annotation.coordinate = coordinate
                annotation.title = response.regeocode.formattedAddress
                mapView!.addAnnotation(annotation)
            }
            
            
            let overlay = MACircle(centerCoordinate: coordinate, radius: 100.0)
            mapView!.addOverlay(overlay)
            
            var str = annotation.title as NSString
            let range = str.rangeOfString("市")
            if range.length > 0 {
               str = str.substringFromIndex(range.location + 1)
            }
            
            cityLabel.text = response.regeocode.addressComponent.city != nil ? response.regeocode.addressComponent.city : response.regeocode.addressComponent.province
            addressLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            addressLabel.numberOfLines = 0
            addressLabel.text = str as String
            self.hud.hide(true)
        }
    }
}