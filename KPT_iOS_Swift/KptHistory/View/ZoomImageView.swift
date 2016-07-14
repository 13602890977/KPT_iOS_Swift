//
//  ZoomImageView.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/7/5.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

protocol ZoomImageViewDelegate:AnyObject {
    func moving(isMoving:Bool)
    func zoomImageDismiss()
}

import UIKit

class ZoomImageView: UIScrollView,UIScrollViewDelegate {
    
    private var containerView : UIView!
    private var myImageView : UIImageView?
    private var rotating : Bool = false
    private var minSize : CGSize?
    
    weak var imageDelegate : ZoomImageViewDelegate!
    
    init(frame:CGRect,imageView:UIImageView) {
        super.init(frame: frame)
        self.delegate = self
        self.bouncesZoom = true
        
        // Add container view
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.clearColor()
        self.addSubview(view)
        containerView = view
        
        
        // Add image view
        
        imageView.frame = containerView.bounds
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        containerView.addSubview(imageView)
        myImageView = imageView;
        
        // Fit container view's size to image size
        let imageSize = imageView.contentSize

        self.containerView.frame = CGRect(x: 0, y: 0, width: imageSize().width, height: imageSize().height)
        
        imageView.bounds = CGRect(x: 0, y: 0, width: imageSize().width, height: imageSize().height)
        
        imageView.center = CGPointMake(imageSize().width / 2, imageSize().height / 2)
        
        self.contentSize = imageSize()
        self.minSize = imageSize()
        
        
        setMaxMinZoomScale()
        centerContent()
        
        setupGestureRecognizer()
        setupRotationNotification()
    }
    func updateImageSize(size:CGSize) {
        var containerRect = containerView.bounds
        containerRect.size = CGSizeMake(SCRW, size.width * SCRH / SCRW)
        containerView.frame = containerRect
        
        myImageView!.frame = containerView.bounds
        
        // Fit container view's size to image size
        let imageSize = myImageView!.contentSize
        
        self.containerView.frame = CGRectMake(0, 0, imageSize().width, imageSize().height)
        myImageView!.bounds = CGRectMake(0, 0, imageSize().width, imageSize().height);
        myImageView!.center = CGPointMake(imageSize().width / 2, imageSize().height / 2)
        
        self.contentSize = imageSize()
        self.minSize = imageSize()
        
        
        setMaxMinZoomScale()
        
        // Center containerView by set insets
        centerContent()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if rotating {
            rotating = false
            // update container view frame
            let containerSize = self.containerView.frame.size;
            let containerSmallerThanSelf = (containerSize.width < CGRectGetWidth(self.bounds)) && (containerSize.height < CGRectGetHeight(self.bounds));
            
            let imageSize = self.myImageView!.image!.sizeThatFits(self.bounds.size)
            
            let minZoomScale = imageSize.width / self.minSize!.width
            self.minimumZoomScale = minZoomScale
            if containerSmallerThanSelf || self.zoomScale == self.minimumZoomScale { // 宽度或高度 都小于 self 的宽度和高度
                self.zoomScale = minZoomScale
            }
            
            // Center container view
            centerContent()
        }
    }
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapHandler:")
        
        tapGestureRecognizer.numberOfTapsRequired = 2;
        containerView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapG = UITapGestureRecognizer(target: self, action: "tapClickDismiss")
        containerView.addGestureRecognizer(tapG)
    }
    func tapClickDismiss() {
        if self.imageDelegate != nil {
            self.imageDelegate.zoomImageDismiss()
        }
    }
    func tapHandler(recognizer:UITapGestureRecognizer)
    {
        if self.zoomScale > self.minimumZoomScale {

            setZoomScale(self.minimumZoomScale, animated: true)
            
        }else if self.zoomScale < self.maximumZoomScale {

            let location = recognizer.locationInView(recognizer.view)
            
            var zoomRect = CGRectMake(0, 0, 50, 50);
            zoomRect.origin = CGPointMake(location.x - CGRectGetWidth(zoomRect)/2, location.y - CGRectGetHeight(zoomRect)/2);
            zoomToRect(zoomRect, animated: true)
        }
    }
    private func setupRotationNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
    }
    func orientationChanged(notification : NSNotification)
    {
        self.rotating = true
    }

    private func centerContent() {
        if self.imageDelegate != nil {
            self.imageDelegate.moving(true)
        }
        
        
        let frame = self.containerView.frame
        
        var top:CGFloat = 0 , left:CGFloat = 0
        if self.contentSize.width < self.bounds.size.width {
            left = (self.bounds.size.width - self.contentSize.width) * CGFloat(0.5)
        }
        if (self.contentSize.height < self.bounds.size.height) {
            top = (self.bounds.size.height - self.contentSize.height) * CGFloat(0.5)
        }
        
        top -= frame.origin.y;
        left -= frame.origin.x;
        
        self.contentInset = UIEdgeInsetsMake(top, left, top, left);
    }
    private func setMaxMinZoomScale() {
        
        let imageSize = self.myImageView?.bounds.size
        
        let imagePresentationSize = self.myImageView?.contentSize;
        let maxScale = max((imageSize?.height)! / imagePresentationSize!().height, (imageSize?.width)! / imagePresentationSize!().width)
        self.maximumZoomScale = max(3.5, maxScale) // Should not less than 1
        self.minimumZoomScale = 1.0;
        
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.containerView
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerContent()
    }
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        self.imageDelegate.moving(true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
