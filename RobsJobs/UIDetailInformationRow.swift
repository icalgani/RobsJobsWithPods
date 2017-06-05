//
//  UIDetailInformationRow.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/18/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit

class UIDetailInformationRow{
    
    func createInformationDetail(logoImage: UIImageView, imageName: String, addtoView: UIView, labelView: UILabel, labelText: String,informationLabel: UILabel, informationDetail: String){
        //        let leadingSize = (self.frame.size.width - 20) / 4
        
        //logo image
        logoImage.image = UIImage(named:imageName)
        addtoView.addSubview(logoImage)
        
        //value label
        labelView.text = labelText
        labelView.font = UIFont(name: "Arial", size: 10)
        labelView.textColor = UIColor.black
        labelView.textAlignment = NSTextAlignment.center
        addtoView.addSubview(labelView)
        
        //information label
        informationLabel.text = informationDetail
        informationLabel.font = UIFont(name: "Arial", size: 10)
        informationLabel.textColor = UIColor(red:0.22, green:0.83, blue:0.65, alpha:1.0)
        informationLabel.textAlignment = NSTextAlignment.center
        addtoView.addSubview(informationLabel)
        
    }
    
    func createDistance(view: UIView, container: UIView, detailView: UIView){
        let detailInformationUI = UIDetailInformationRow()
        let leadingSize = (view.frame.size.width - 20) / 4

        //distance detail view
        
        view.addSubview(detailView)
        //distance detail view constraint
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailInformationUI.createDetailConstraint(container: detailView, leadingToItem: container, leadingSize: 0, frameSizeWidth: Float(leadingSize), ToItem: container)
    }
    
    func createDetailConstraint(container: UIView, leadingToItem: UIView, leadingSize: Float, frameSizeWidth: Float,ToItem: UIView){
        NSLayoutConstraint(item: container,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: leadingToItem,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: CGFloat(leadingSize)).isActive = true
        
        NSLayoutConstraint(item: container,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: ToItem,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: container,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: CGFloat(frameSizeWidth)).isActive = true
        
        NSLayoutConstraint(item: container,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: ToItem,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
    }
}
