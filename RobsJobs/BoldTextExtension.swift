//
//  BoldTextExtension.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/5/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    func bold(_ text:String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "AvenirNext-Medium", size: 12)!]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    func colourDeepGreen() -> NSMutableAttributedString {
    let range = (self.string as NSString).range(of: self.string)
        
        let attribute = NSMutableAttributedString.init(string: self.string)
        attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.00, green:0.59, blue:0.53, alpha:1.0) , range: range)
        return self
    }
    
    func normal(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}
