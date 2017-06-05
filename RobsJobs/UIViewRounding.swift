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
}
