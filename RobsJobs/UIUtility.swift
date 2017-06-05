//
//  UIUtility.swift
//  RobsJobs
//
//  Created by MacBook on 4/3/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit

class UIUtility{
    
    func setBackgroundColorGreen(View: UIViewController){
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_login")
        View.view.insertSubview(backgroundImage, at: 0)
    }
    
    //set status bar color
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    //change Hex to UIColor
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func stylingImage(button: UIButton){
        
        button.titleEdgeInsets.right = button.frame.size.width
        button.setImage(UIImage(named: "icon_dropdown"), for: UIControlState.normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
        
//        button.imageView?.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -8.0).isActive = true
//        button.imageView?.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0.0).isActive = true
//        button.contentHorizontalAlignment = .left
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
//    
//    func addUIBarPad(textfield: UITextField){
//        let numberToolbar: UIToolbar = UIToolbar()
//        
//        numberToolbar.barStyle = UIBarStyle.blackTranslucent
//        numberToolbar.items=[
//            UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.plain, target: self, action: #selector(clearText(textfield: ))),
//            
//            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
//            UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goToNextField(textfield: )))
//        ]
//        
//        numberToolbar.sizeToFit()
//        
//        textfield.inputAccessoryView = numberToolbar //do it for every relevant textfield if there are more than one
//    }
//    
//    
//    @objc func clearText(textfield: UITextField) {
//    textfield.text = ""
//    }
//    
//    @objc func goToNextField (textfield: UITextField) -> Bool
//    {
//        // Try to find next responder
//        if let nextField = textfield.superview?.viewWithTag(textfield.tag + 1) as? UITextField {
//            nextField.becomeFirstResponder()
//        } else {
//            // Not found, so remove keyboard.
//            textfield.resignFirstResponder()
//        }
//        // Do not add a line break
//        return false
//    }
    
}

