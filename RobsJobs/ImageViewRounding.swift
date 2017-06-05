//
//  TextfieldPaddingExtension.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/4/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    func roundingImage(){
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
