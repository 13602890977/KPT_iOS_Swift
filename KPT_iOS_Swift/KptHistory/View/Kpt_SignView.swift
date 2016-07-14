//
//  Kpt_SignView.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/30.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class Kpt_SignView: UIView {

    private var previousPoint : CGPoint!
    
    // 绘制路径
    private var path = UIBezierPath()
    // 存储绘制时最新的5个点坐标
    private var pts = [CGPoint](count: 5, repeatedValue: CGPoint())
    // 索引，同上面的pts配合。每有5个点的话则绘制一段曲线，依次循环。整个签名图就是由一段段曲线组成的。
    private var ctr = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        ///画线宽度
        self.path.lineWidth = 3.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Draw
    override internal func drawRect(rect: CGRect) {
        UIColor.blackColor().setStroke()//画线颜色
        self.path.stroke()
    }
    // 触摸签名相关方法
    override internal func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let firstTouch = touches.first{
            let touchPoint = firstTouch.locationInView(self)
            self.ctr = 0
            self.pts[0] = touchPoint
        }
    }
    
    override internal func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let firstTouch = touches.first{
            let touchPoint = firstTouch.locationInView(self)
            self.ctr++
            self.pts[self.ctr] = touchPoint
            if (self.ctr == 4) {
                self.pts[3] = CGPointMake((self.pts[2].x + self.pts[4].x)/2.0,
                    (self.pts[2].y + self.pts[4].y)/2.0)
                self.path.moveToPoint(self.pts[0])
                self.path.addCurveToPoint(self.pts[3], controlPoint1:self.pts[1],
                    controlPoint2:self.pts[2])
                
                self.setNeedsDisplay()
                self.pts[0] = self.pts[3]
                self.pts[1] = self.pts[4]
                self.ctr = 1
            }
            
            self.setNeedsDisplay()
        }
    }
    
    override internal func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.ctr == 0{
            let touchPoint = self.pts[0]
            self.path.moveToPoint(CGPointMake(touchPoint.x-1.0,touchPoint.y))
            self.path.addLineToPoint(CGPointMake(touchPoint.x+1.0,touchPoint.y))
            self.setNeedsDisplay()
        } else {
            self.ctr = 0
        }
    }
    
    // 签名视图清空
    internal func clearSignature() {
        self.path.removeAllPoints()
        self.setNeedsDisplay()
    }
    // 将签名保存为UIImage
    internal func getSignature() ->UIImage {
        UIGraphicsBeginImageContext(CGSizeMake(self.bounds.size.width,
            self.bounds.size.height))
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let signature: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return signature
    }

    
}
