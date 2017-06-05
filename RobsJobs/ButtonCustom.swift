//
//  ButtonCustom.swift
//  RobsJobs
//
//  Created by MacBook on 4/3/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class ButtonCustom: UIButton {
    
    var title = UILabel()
    var lineLayer : CALayer?
    
    func whiteBorder(){
        backgroundColor = .clear
        layer.cornerRadius = 5
        layer.borderWidth = 3
        layer.borderColor = UIColor.white.cgColor
    }
    
    func roundingButton(){
        layer.cornerRadius = 5
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
