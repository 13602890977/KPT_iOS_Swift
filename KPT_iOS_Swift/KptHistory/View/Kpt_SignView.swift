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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    func midpoint(p0:CGPoint,p1:CGPoint) -> CGPoint {
        let pointX = (p0.x + p1.x)/2
        let pointY = (p0.y + p1.y)/2
        let point = CGPoint(x: pointX, y: pointY)
        return point
    }
    
    override func drawRect(rect: CGRect) {
        
        line()
    }
    
    func line() {
        //获取当前上下文，
        let context = UIGraphicsGetCurrentContext()
        //开始上下文
        CGContextBeginPath(context)
        //设置线宽
        CGContextSetLineWidth(context, 4.0)
        
        //线条拐角样式，设置为平滑
        CGContextSetLineJoin(context, CGLineJoin.Round)
        //线条开始样式，设置为平滑
        CGContextSetLineCap(context, CGLineCap.Round)
        
        //查看lineArray数组里是否有线条，有就将之前画的重绘，没有只画当前线条
        if (lineArray.count > 0) {
            for (var i = 0; i < lineArray.count; i++) {
                let array = NSArray(array: lineArray[i] as! NSArray)
                
                if (array.count > 0)
                {
                    CGContextBeginPath(context);
                    let myStartPoint = CGPointFromString(array.objectAtIndex(0) as! String)
                    previousPoint = myStartPoint
                    CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y)
                    
                    for (var j=0; j < array.count - 1; j++)
                    {
                        let myEndPoint = CGPointFromString(array.objectAtIndex(j+1) as! String);
                        //--------------------------------------------------------
                        let midPoint = midpoint(previousPoint, p1: myEndPoint)
                        CGContextAddQuadCurveToPoint(context, midPoint.x, midPoint.y, myEndPoint.x, myEndPoint.y)
                        //                        CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y)
                        previousPoint = myEndPoint
                    }
                    
                    //设置线条的颜色，要取uicolor的CGColor
                    CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
                    //-------------------------------------------------------
                    //设置线条宽度
                    CGContextSetLineWidth(context, 4.0)
                    //保存自己画的
                    CGContextStrokePath(context);
                }
            }
        }
        //画当前的线
        if (pointArray.count > 0)
        {
            CGContextBeginPath(context);
            let myStartPoint = CGPointFromString(pointArray.objectAtIndex(0) as! String)
            previousPoint = myStartPoint
            CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
            
            for (var j = 0; j < pointArray.count - 1; j++)
            {
                let myEndPoint = CGPointFromString(pointArray.objectAtIndex(j+1) as! String);
                //--------------------------------------------------------
                let midPoint = midpoint(previousPoint, p1: myEndPoint)
                CGContextAddQuadCurveToPoint(context, midPoint.x, midPoint.y, myEndPoint.x, myEndPoint.y)
                //                        CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y)
                previousPoint = myEndPoint
            }
            
            CGContextSetStrokeColorWithColor(context,UIColor.blackColor().CGColor);
            //-------------------------------------------------------
            CGContextSetLineWidth(context, 4.0);
            CGContextStrokePath(context);
        }
        
    }
    //在touch结束前将获取到的点，放到pointArray里
    private func addPA(nPoint:CGPoint) {
        let sPoint = NSStringFromCGPoint(nPoint)
        pointArray.addObject(sPoint)
    }
    //在touchend时，将已经绘制的线条的颜色，宽度，线条线路保存到数组里
    private func addLA() {
        let array = NSArray(array: pointArray)
        lineArray.addObject(array)
        pointArray = NSMutableArray()
    }
    
    //手指开始触屏开始
    var MyBeganpoint : CGPoint!
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    //手指移动时候发出
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = (touches as NSSet).anyObject()
        MyBeganpoint = touch!.locationInView(self)
        let sPoint = NSStringFromCGPoint(MyBeganpoint);
        pointArray.addObject(sPoint)
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        addLA()
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        //电话呼入取消事件
        print("touches Canelled")
    }
    ///重绘
    func clear() {
        pointArray.removeAllObjects()
        lineArray.removeAllObjects()
        deleArray.removeAllObjects()
        self.setNeedsDisplay()
    }
    
    
    //经过的点的数组
    private lazy var pointArray : NSMutableArray = NSMutableArray()
    //线条数组
    private lazy var lineArray : NSMutableArray = NSMutableArray()
    //删除的数组
    private lazy var deleArray : NSMutableArray = NSMutableArray()
    
    
    ///使用二次贝塞尔曲线
    /*
    override init(frame: CGRect) {
    super.init(frame: frame)
    path = UIBezierPath()
    path.lineWidth = 3.0
    path.lineCapStyle = CGLineCap.Butt
    path.lineJoinStyle = CGLineJoin.Round
    }
    required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    path = UIBezierPath()
    
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    path.stroke()
    }
    
    //手指开始触屏开始
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let touch = (touches as NSSet).anyObject()
    previousPoint = touch!.locationInView(self)
    path.moveToPoint(previousPoint)
    }
    //手指移动时候发出
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let touch = (touches as NSSet).anyObject()
    
    let  currentPoint = touch!.locationInView(self)
    
    let  midPoint = midpoint(previousPoint, p1: currentPoint)
    
    path.addQuadCurveToPoint(midPoint, controlPoint: currentPoint)
    
    previousPoint = currentPoint
    
    self.setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    //电话呼入取消事件
    print("touches Canelled")
    }
    
    func midpoint(p0:CGPoint,p1:CGPoint) -> CGPoint {
    let pointX = (p0.x + p1.x)/2
    let pointY = (p0.y + p1.y)/2
    let point = CGPoint(x: pointX, y: pointY)
    return point
    }

    */
}
