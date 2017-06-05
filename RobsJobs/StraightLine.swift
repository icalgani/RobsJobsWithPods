//
//  StraightLine.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/26/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit

public class StraightLine: UIView
{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ frame: CGRect) {
        let h = frame.height
        let w = frame.width
        let color:UIColor = UIColor.black
        
        let drect = CGRect(x: 1, y: 10, width: w, height: h)
        let bpath:UIBezierPath = UIBezierPath(rect: drect)
        
        color.set()
        bpath.stroke()
        
        print("it ran")
        NSLog("drawRect has updated the view")
    }
}
