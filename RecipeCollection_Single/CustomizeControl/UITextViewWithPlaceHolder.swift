//
//  UITextViewWithPlaceHolder.swift
//  RecipeCollection_Single
//
//  Created by Andy Xu on 7/28/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class UITextViewWithPlaceHolder: UITextView, UITextViewDelegate {
    @IBInspectable var placeholder: String = ""
    @IBInspectable var normalTextColor: UIColor = UIColor.blackColor()
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGrayColor()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        delegate = self
        text = placeholder
        textColor = placeholderColor
        
        layer.borderColor = UIColor.grayColor().CGColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        switch key {
        case "placeholder":
            if let value = value as? String {
                placeholder = value
            }
        case "normalTextColor":
            if let value = value as? UIColor {
                normalTextColor = value
            }
        case "placeholderColor":
            if let value = value as? UIColor {
                placeholderColor = value
            }
        case "text":
            text = value as? String
            if let string = text where !string.isEmpty {
                text = placeholder
                textColor = placeholderColor
            } else {
                textColor = normalTextColor
            }
        default:
            super.setValue(value, forUndefinedKey: key)
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == placeholderColor {
            textView.text = ""
            textView.textColor = normalTextColor
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = placeholderColor
        }
    }
}
