//
//  InputButton.swift
//  RobsJobs
//
//  Created by MacBook on 4/5/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation

import UIKit

class InputButton: UIButton{
    
    var lineLayer : CALayer?
    
    override func layoutSubviews() {
        
        //this is my own custom underline
        super.layoutSubviews()
        self.lineLayer?.removeFromSuperlayer()
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.bounds.height-7, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.white.cgColor
        self.layer.addSublayer(bottomLine)
        self.lineLayer = bottomLine
    }
}
