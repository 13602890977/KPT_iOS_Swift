//
//  Kpt_textField.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/7/15.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

@objc protocol KptTextFieldDelegate : AnyObject {
    @objc optional func textViewReturnText(str:String?)
}

typealias returnTextBlock = (text:String?) ->Void

class Kpt_textField: UIView,UITextViewDelegate {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var layout: NSLayoutConstraint!
    @IBOutlet weak var placeholderLabel: UILabel!

    private var returnText:returnTextBlock!
    var placeholder : String! {
        didSet {
            titleLabel.text = "请输入" + placeholder
            placeholderLabel.text = "请输入" + placeholder
        }
    }
    ///接收placeholder
    var detailsStr : String! {
        didSet {
            if detailsStr.hasPrefix("请输入") {
                placeholderLabel.hidden = false
            }else {
                mainTextView.text = detailsStr
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 5
        
        mainTextView.clipsToBounds = true
        self.mainTextView.layer.cornerRadius = 5
        mainTextView.layer.borderWidth = 0.5
        mainTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        mainTextView.delegate = self
        mainTextView.editable = true
        //设置高度
        layout.constant = 240
        mainView.setNeedsLayout()
        
        mainTextView.becomeFirstResponder()
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func textViewDidChange(textView: UITextView) {
        let attr = NSDictionary(object: UIFont.systemFontOfSize(18), forKey: NSFontAttributeName)
        let maxSize = CGSizeMake(SCRW - 80, CGFloat(MAXFLOAT))
        let option = NSStringDrawingOptions.UsesLineFragmentOrigin
        let str : NSString = textView.text
        let size = str.boundingRectWithSize(maxSize, options: option, attributes: attr as? [String : AnyObject], context: nil).size
        if size.height > 80 {
            
            layout.constant = 200 + size.height - 40
            mainView.setNeedsLayout()
        }
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.mainTextView.resignFirstResponder()
            return false
        }else {
            if text != "" {
                placeholderLabel.hidden = true
            }
            if range.length == 1 && range.location == 0 {
                placeholderLabel.hidden = false
            }
            return true
        }
    }
    @IBAction func cancelBtnClick(sender: AnyObject) {
        self.removeFromSuperview()
    }
    @IBAction func sureBtnClick(sender: AnyObject) {
        if returnText != nil {
            returnText(text: mainTextView.text)
        }
        self.removeFromSuperview()
    }
    func returnSelectedResult(result:returnTextBlock) {
        self.returnText = result
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.removeFromSuperview()
    }
}
