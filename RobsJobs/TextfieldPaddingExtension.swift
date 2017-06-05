//
//  TextfieldPaddingExtension.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/4/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setGrayBorderWithpadding(_ padding:CGFloat){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.setLeftPaddingPoints(padding)
    }
    func setLineSeparator(_ space: CGFloat, lineWidth: CGFloat){
        let border = CALayer()
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0,y: space, width: lineWidth,height: self.frame.height - (space * 2))
        
        border.borderWidth = lineWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
