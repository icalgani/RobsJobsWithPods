//
//  UIViewRounding.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/9/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func roundingUIView(){
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func setSettingBoxView(){
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0,height: 1)
    }
}
