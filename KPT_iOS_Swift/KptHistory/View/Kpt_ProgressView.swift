//
//  Kpt_ProgressView.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/28.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class Kpt_ProgressView: UIView {
    ///中心颜色
    var centerColor : UIColor?
    
    ///圆环色(显示占有的)
    var arcFinishColor:UIColor?
    ///圆环色(显示没有占有的)
    var arcUnfinishColor:UIColor?
    
    ///圆环背景色
    var arcBackColor : UIColor?
    
    ///百分比数值(0-1)
    var percent : Float = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    ///圆环宽度
    var width : Int = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        addArcBackColor()
        drawArc()
        addCenterBack()
        addCenterLabel()
    }

    private func addArcBackColor() {
        var color = UIColor.lightGrayColor().CGColor
        if arcBackColor != nil {
            color = (arcBackColor?.CGColor)!
        }
        let contextRef = UIGraphicsGetCurrentContext()
        let viewSize = self.bounds.size
        let center = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.5)
        let radius = viewSize.height * 0.5
        
        CGContextBeginPath(contextRef)
        CGContextMoveToPoint(contextRef, center.x, center.y)
        CGContextAddArc(contextRef, center.x, center.y, radius, 0 , CGFloat(2.0 * M_PI), 0)
        CGContextSetFillColorWithColor(contextRef, color)
        CGContextFillPath(contextRef)
        
    }
    private func drawArc() {
        if percent == 0 || percent > 1 {
            return
        }
        var color = UIColor.lightGrayColor().CGColor
        
        let contextRef = UIGraphicsGetCurrentContext()
        let viewSize = self.bounds.size
        let center = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.5)
        let radius = viewSize.height * 0.5
        
        var endAngle : CGFloat = 0
        
        CGContextBeginPath(contextRef)
        CGContextMoveToPoint(contextRef, center.x, center.y)
        if percent == 1 {
            if arcFinishColor != nil {
                color = (arcFinishColor?.CGColor)!
            }
            endAngle = CGFloat(2.0 * M_PI)
        }else {
            if arcUnfinishColor != nil {
                color = (arcUnfinishColor?.CGColor)!
            }
             endAngle = CGFloat(2.0 * M_PI * Double(percent))
        }
        CGContextAddArc(contextRef, center.x, center.y, radius, 0 , endAngle, 0)
        CGContextSetFillColorWithColor(contextRef, color)
        CGContextFillPath(contextRef)
        
    }
    private func addCenterBack() {
        let newWidth = (width == 0) ? 5 : width
        
        var color = UIColor.whiteColor().CGColor
        if centerColor != nil {
            color = (centerColor?.CGColor)!
        }
        let contextRef = UIGraphicsGetCurrentContext()
        let viewSize = self.bounds.size
        let center = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.5)
        let radius = viewSize.height * 0.5 - CGFloat(newWidth)
        
        CGContextBeginPath(contextRef)
        CGContextMoveToPoint(contextRef, center.x, center.y)
        CGContextAddArc(contextRef, center.x, center.y, radius, 0 , CGFloat(2.0 * M_PI), 0)
        CGContextSetFillColorWithColor(contextRef, color)
        CGContextFillPath(contextRef)
    }
    private func addCenterLabel() {
       var percentStr = "";
        
        var fontSize : CGFloat = 14;
        var arcColor = UIColor.blueColor()
        
        if percent == 1  {
            percentStr = "100%"
            fontSize = 14
            arcColor = (arcFinishColor == nil) ? UIColor.greenColor() : arcFinishColor!
            
        }else if percent < 1 && percent >= 0 {
            
            fontSize = 14;
            arcColor = (arcUnfinishColor == nil) ? UIColor.blueColor() : arcUnfinishColor!
            percentStr = "\(percent*100)%"
        }
        
        let viewSize = self.bounds.size;
        let paragraph = NSMutableParagraphStyle()
        
        paragraph.alignment = NSTextAlignment.Center;
        let attributes = [
            NSFontAttributeName : UIFont.boldSystemFontOfSize(fontSize),
            NSForegroundColorAttributeName : arcColor,
            NSBackgroundColorAttributeName:UIColor.clearColor(),
            NSParagraphStyleAttributeName : paragraph
        ]
        
       (percentStr as NSString).drawInRect(CGRect(x: 5, y: (viewSize.height-fontSize) * 0.5, width: viewSize.width-10, height: fontSize), withAttributes: attributes)
    }

}
