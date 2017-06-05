//
//  JobRequirementDetail.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/5/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
import UIKit

class JobRequirementDetail{
    
    func createJobRequirementDetail(view: UIView, container: UIView, typeLabel: UILabel, salaryLabel: UILabel, experienceLabel: UILabel){
        
        let typeLogo = UIImageView(frame: CGRect(x:0 ,y:0 ,width: 15, height: 15))
        typeLogo.image = UIImage(named: "RJ_work_icon")
        container.addSubview(typeLogo)
        
        typeLogo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: typeLogo,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: container,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: typeLogo,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: container,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 5.0).isActive = true
        
        //information label
        typeLabel.text = "No Info Given"
        typeLabel.font = UIFont.boldSystemFont(ofSize: 10)
        typeLabel.textColor = UIColor(red:0.00, green:0.59, blue:0.53, alpha:1.0)
        container.addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint(item: typeLabel,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: typeLogo,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 5.0).isActive = true
        
        NSLayoutConstraint(item: typeLabel,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: container,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 5.0).isActive = true
        
        NSLayoutConstraint(item: typeLabel,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 12.0).isActive = true
        
        createEachDetail(logoName: "RJ_sallary_icon", requirementDetailLabel: salaryLabel, container: container, topConstraintTo: typeLabel)
        
        createEachDetail(logoName: "RJ_experience_icon", requirementDetailLabel: experienceLabel, container: container, topConstraintTo: salaryLabel)
    }
    
    func createEachDetail(logoName: String, requirementDetailLabel: UILabel, container: UIView, topConstraintTo: UILabel){
        let logoImage = UIImageView(frame: CGRect(x:0 ,y:0 ,width: 15, height: 15))
        logoImage.image = UIImage(named: logoName)
        container.addSubview(logoImage)
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: logoImage,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: container,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: logoImage,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: topConstraintTo,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 7.0).isActive = true
        
        //information label
        requirementDetailLabel.text = "No Info Given"
        requirementDetailLabel.font = UIFont.boldSystemFont(ofSize: 10)
        requirementDetailLabel.textColor = UIColor(red:0.00, green:0.59, blue:0.53, alpha:1.0)
        container.addSubview(requirementDetailLabel)
        requirementDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint(item: requirementDetailLabel,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: logoImage,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 5.0).isActive = true
        
        NSLayoutConstraint(item: requirementDetailLabel,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: topConstraintTo,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 7.0).isActive = true
        
        NSLayoutConstraint(item: requirementDetailLabel,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 12.0).isActive = true

    }
    
    //DESCRIPTION
    func createJobDescriptionView(container: UIView, jobDescriptionLabel: UILabel){
        jobDescriptionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
        jobDescriptionLabel.font = UIFont(name: "Arial", size: 12)
        jobDescriptionLabel.lineBreakMode = NSLineBreakMode.byTruncatingHead
        jobDescriptionLabel.numberOfLines = 0
        container.addSubview(jobDescriptionLabel)
        jobDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint(item: jobDescriptionLabel,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: container,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 5.0).isActive = true
        
        NSLayoutConstraint(item: jobDescriptionLabel,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: container,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: -10.0).isActive = true
        
        NSLayoutConstraint(item: jobDescriptionLabel,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 60.0).isActive = true
        
        NSLayoutConstraint(item: jobDescriptionLabel,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: container,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
    }
    
    //FOOTER
    func createCardFooter(view: UIView, appliedNumberLabel: UILabel, offerRemainingLabel: UILabel, topConstraint: UIButton){
        //Stack View
        let stackView   = UIStackView()
        stackView.axis  = UILayoutConstraintAxis.horizontal
        stackView.distribution  = UIStackViewDistribution.fillEqually
        stackView.alignment = .center
        stackView.spacing   = 0.0
        
        //APPLIED View
        let appliedView = UIView()
        
        
        //REMAINING DAYS VIEW
        let offerRemainingView = UIView()
        
        //add view to stackView
        stackView.addArrangedSubview(appliedView)
        stackView.addArrangedSubview(offerRemainingView)
        appliedView.center = stackView.center
        offerRemainingView.center = stackView.center
        
        //add stackview to cardview
        view.addSubview(stackView)
        
        //create applied image and add to applied view
        let appliedImage = UIImageView(frame: CGRect(x:0 ,y:0 ,width: 15, height: 15))
        appliedImage.image = UIImage(named: "RJ_location_icon")
        appliedImage.contentMode = UIViewContentMode.scaleAspectFit
        appliedView.addSubview(appliedImage)
        
        //create offer remaining image and add to offer remaining view
        let offerImage = UIImageView(frame: CGRect(x:0 ,y:0 ,width: 15, height: 15))
        offerImage.image = UIImage(named: "RJ_expired_icon")
        offerImage.contentMode = UIViewContentMode.scaleAspectFit
        offerRemainingView.addSubview(offerImage)
        
        //add labels
        appliedView.addSubview(appliedNumberLabel)
        offerRemainingView.addSubview(offerRemainingLabel)
        
        //CREATE STACKVIEW CONSTRAINT
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: stackView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: stackView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: stackView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: topConstraint,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 15.0).isActive = true
        
        NSLayoutConstraint(item: stackView,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant:20.0).isActive = true
        
        appliedView.translatesAutoresizingMaskIntoConstraints = false
        appliedNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        appliedImage.translatesAutoresizingMaskIntoConstraints = false
        
        offerRemainingView.translatesAutoresizingMaskIntoConstraints = false
        offerImage.translatesAutoresizingMaskIntoConstraints = false
        offerRemainingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setFooterViewConstraint(container: appliedView, logoImage: appliedImage, informationLabel: appliedNumberLabel, stackview: stackView)
        setFooterViewConstraint(container: offerRemainingView, logoImage: offerImage, informationLabel: offerRemainingLabel, stackview: stackView)
    }
    
    func setFooterViewConstraint(container: UIView, logoImage: UIImageView, informationLabel: UILabel, stackview: UIStackView){
        
        //information label
        informationLabel.text = "No Info Given"
        informationLabel.font = UIFont(name: "Arial", size: 10)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        //IMAGE CONSTRAINT
        NSLayoutConstraint(item: logoImage,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: container,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 10.0).isActive = true
        
        NSLayoutConstraint(item: logoImage,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: container,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        //LABEL CONSTRAINT
        NSLayoutConstraint(item: informationLabel,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: logoImage,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 3.0).isActive = true
        
        NSLayoutConstraint(item: informationLabel,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: container,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 2.0).isActive = true
        
        NSLayoutConstraint(item: informationLabel,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 10.0).isActive = true
    }
}
