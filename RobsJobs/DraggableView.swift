//
//  DraggableView.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import Foundation
import UIKit

let ACTION_MARGIN: Float = 120      //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
let SCALE_STRENGTH: Float = 4       //%%% how quickly the card shrinks. Higher = slower shrinking
let SCALE_MAX:Float = 1          //%%% upper bar for how much the card shrinks. Higher = shrinks less
let ROTATION_MAX: Float = 1         //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
let ROTATION_STRENGTH: Float = 1000  //%%% strength of rotation. Higher = weaker rotation
let ROTATION_ANGLE: Float = 3.14/16  //%%% Higher = stronger rotation angle

protocol DraggableViewDelegate {
    func cardSwipedLeft(card: UIView) -> Void
    func cardSwipedRight(card: UIView) -> Void
    
    func tapForMorePressed(button: UIButton) -> Void

}

class DraggableView: UIView {
    var delegate: DraggableViewDelegate!
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    var originPoint: CGPoint!
    var overlayView: OverlayView!
    var xFromCenter: Float!
    var yFromCenter: Float!
    
    var companyID: Int!
    
    var companyNameLabel: UILabel!
    var jobOfferLabel: UILabel!
    var companyLogoView: UIImageView!
    var containerDetail: UIView!
    var distanceDetailView: UIView!
    var typeDetailView: UIView!
    var salaryDetailView: UIView!
    var experienceDetailView: UIView!
    
    var requiredSkillView: UIView!
    
    var locationLogo: UIImageView!
    var locationLabel: UILabel!
    var informationLocationLabel: UILabel!
    
    var typeLogo: UIImageView!
    var typeLabel: UILabel!
    var informationTypesLabel: UILabel!
    
    var salaryLogo: UIImageView!
    var salaryLabel: UILabel!
    var informationSalaryLabel: UILabel!
    
    var experienceLogo: UIImageView!
    var experienceLabel: UILabel!
    var informationExperienceLabel: UILabel!
    
    var jobDescriptionLabel: UILabel!
    
    var requiredSkill: [String] = []
    var requiredSkillLabel: UILabel!
    
    var offerTimeView: UIView!
    var offerTimeLabel: UILabel!
    
    var moreButtonView: UIView!
    var moreButton: UIButton!
    
    var appliedNumberLabel: UILabel!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupView()

        self.backgroundColor = UIColor.white

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged(_:)))

        self.addGestureRecognizer(panGestureRecognizer)

        overlayView = OverlayView(frame: CGRect(x: self.frame.size.width/2-100,y: 0,width: 100,height: 100))
        overlayView.alpha = 0
        self.addSubview(overlayView)
        
        setUpDraggableContent()
        
        xFromCenter = 0
        yFromCenter = 0
    }
    
    func setUpDraggableContent(){
        //DETAIL REQUIREMENT
        typeLabel = UILabel()
        salaryLabel = UILabel()
        experienceLabel = UILabel()
        locationLabel = UILabel()
        
        //company Logo
        companyLogoView = UIImageView(frame: CGRect(x: 10,y: 5,width: self.frame.width - 10,height: 70))
        companyLogoView.image = UIImage(named:"logocard")
        companyLogoView.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(companyLogoView)

        jobOfferLabel = UILabel(frame: CGRect(x: 0,y: 0, width: 200,height: 16))
        jobOfferLabel.text = "no info given"
        jobOfferLabel.textColor = UIColor.black
        jobOfferLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.addSubview(jobOfferLabel)
        jobOfferLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //JOB OFFER LABEL CONSTRAINT
        NSLayoutConstraint(item: jobOfferLabel,
                           attribute: .top, relatedBy: .equal,
                           toItem: companyLogoView,
                           attribute: .bottom, multiplier: 1.0,
                           constant: 5.0).isActive = true
        
        NSLayoutConstraint(item: jobOfferLabel,
                           attribute: .leading, relatedBy: .equal,
                           toItem: self,
                           attribute: .leading, multiplier: 1.0,
                           constant: 10.0).isActive = true
        
        NSLayoutConstraint(item: jobOfferLabel,
                           attribute: .trailing, relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing, multiplier: 1.0,
                           constant: -10.0).isActive = true
        
        NSLayoutConstraint(item: jobOfferLabel,
                           attribute: .width,
                           relatedBy: .greaterThanOrEqual,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 50).isActive = true
        
        NSLayoutConstraint(item: jobOfferLabel,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 16).isActive = true
        
        //company name
        companyNameLabel = UILabel(frame: CGRect(x: 0,y: 0, width: 30,height: 10))
        companyNameLabel.text = "no info given"
        companyNameLabel.textColor = UIColor.black
        companyNameLabel.font = UIFont(name: companyNameLabel.font.fontName, size: 10)
        companyNameLabel.textAlignment = NSTextAlignment.left
        self.addSubview(companyNameLabel)
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //COMPANY LABEL CONSTRAINT
        NSLayoutConstraint(item: companyNameLabel,
                           attribute: .top, relatedBy: .equal,
                           toItem: jobOfferLabel,
                           attribute: .bottom, multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: companyNameLabel,
                           attribute: .trailing, relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing, multiplier: 1.0,
                           constant: -20.0).isActive = true
        
        NSLayoutConstraint(item: companyNameLabel,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 10).isActive = true
        
        NSLayoutConstraint(item: companyNameLabel,
                           attribute: .width,
                           relatedBy: .greaterThanOrEqual,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 50).isActive = true
        
        NSLayoutConstraint(item: companyNameLabel,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 16).isActive = true
        
        companyNameLabel.clipsToBounds = true
        
        //container detail
        containerDetail = UIView()
        self.addSubview(containerDetail)
        //container constraint
        containerDetail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: containerDetail,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 5.0).isActive = true
        
        NSLayoutConstraint(item: containerDetail,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: -10.0).isActive = true
        
        NSLayoutConstraint(item: containerDetail,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: companyNameLabel,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true

        
        let jobRequirementDetail = JobRequirementDetail()
        
        jobRequirementDetail.createJobRequirementDetail(view: self, container: containerDetail, typeLabel: typeLabel, salaryLabel: salaryLabel, experienceLabel: experienceLabel)
        
        NSLayoutConstraint(item: containerDetail,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: experienceLabel,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        //JOB DESCRIPTION CONTAINER VIEW
        let descriptionContainerView = UIView()
        self.addSubview(descriptionContainerView)
        
        //JOB DESCRIPTION CONSTRAINT
        descriptionContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: descriptionContainerView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 5.0).isActive = true
        
        NSLayoutConstraint(item: descriptionContainerView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: -5.0).isActive = true
        
        NSLayoutConstraint(item: descriptionContainerView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: containerDetail,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 5.0).isActive = true
        
        NSLayoutConstraint(item: descriptionContainerView,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 30.0).isActive = true
        
        jobDescriptionLabel = UILabel()
        //CREATE JOB DESCRIPTION
        jobRequirementDetail.createJobDescriptionView(container: descriptionContainerView, jobDescriptionLabel: jobDescriptionLabel)
        
        //create button
        //        detailInformationUI.createTapForMoreButton(view: self)
        moreButtonView = UIView()
        self.addSubview(moreButtonView)
        
        moreButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: moreButtonView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant:10.0).isActive = true
        
        NSLayoutConstraint(item: moreButtonView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: -10.0).isActive = true
        
        NSLayoutConstraint(item: moreButtonView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: jobDescriptionLabel,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 5.0).isActive = true
        
        NSLayoutConstraint(item: moreButtonView,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 30.0).isActive = true
        
        moreButton = UIButton(frame: CGRect(x: 0,y: 0,width: self.frame.size.width - 20,height: 15))
        moreButton.backgroundColor = UIColor.clear
        moreButton.setTitle("More", for: .normal)
        moreButton.setTitleColor(UIColor(red:0.00, green:0.59, blue:0.53, alpha:1.0), for: .normal)
        moreButton.addTarget(self, action: #selector(self.action(_:)), for: UIControlEvents.touchUpInside)
        moreButtonView.addSubview(moreButton)
        
        appliedNumberLabel = UILabel()
        offerTimeLabel = UILabel()
        //CREATE CARD FOOTER
        jobRequirementDetail.createCardFooter(view: self, appliedNumberLabel: appliedNumberLabel, offerRemainingLabel: offerTimeLabel, topConstraint: moreButton)
    }
    //end setup draggable content
    
    func action(_ button:UIButton!) -> Void {
        //delegate tap for more button
            delegate.tapForMorePressed(button: button)
    }
    
    
    func setupView() -> Void {
        self.layer.cornerRadius = 4;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.6;
        self.layer.shadowOffset = CGSize(width: 1,height: 1);
    }

    func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) -> Void {
        xFromCenter = Float(gestureRecognizer.translation(in: self).x)
        yFromCenter = Float(gestureRecognizer.translation(in: self).y)
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.began:
            self.originPoint = self.center
        case UIGestureRecognizerState.changed:
            let rotationStrength: Float = min(xFromCenter/ROTATION_STRENGTH, ROTATION_MAX)
            let rotationAngle = ROTATION_ANGLE * rotationStrength
            let scale = max(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX)

            self.center = CGPoint(x: self.originPoint.x + CGFloat(xFromCenter),y: self.originPoint.y + CGFloat(yFromCenter))

            let transform = CGAffineTransform(rotationAngle: CGFloat(rotationAngle))
            let scaleTransform = transform.scaledBy(x: CGFloat(scale), y: CGFloat(scale))
            self.transform = scaleTransform
            self.updateOverlay(distance: CGFloat(xFromCenter))
        case UIGestureRecognizerState.ended:
            self.afterSwipeAction()
        case UIGestureRecognizerState.possible:
            fallthrough
        case UIGestureRecognizerState.cancelled:
            fallthrough
        case UIGestureRecognizerState.failed:
            fallthrough
        default:
            break
        }
    }

    func updateOverlay(distance: CGFloat) -> Void {
        if distance > 0 {
            overlayView.setMode(mode: GGOverlayViewMode.GGOverlayViewModeRight)
        } else {
            overlayView.setMode(mode: GGOverlayViewMode.GGOverlayViewModeLeft)
        }
        overlayView.alpha = CGFloat(min(fabsf(Float(distance))/100, 0.4))
    }

    func afterSwipeAction() -> Void {
        let floatXFromCenter = Float(xFromCenter)
        if floatXFromCenter > ACTION_MARGIN {
            self.rightAction()
        } else if floatXFromCenter < -ACTION_MARGIN {
            self.leftAction()
        } else {
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.center = self.originPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
                self.overlayView.alpha = 0
            })
        }
    }
    
    func rightAction() -> Void {
        
        let finishPoint: CGPoint = CGPoint(x: 500,y: 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animate(withDuration: 0.3,
            animations: {
                self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedRight(card: self)
    }

    func leftAction() -> Void {
        let finishPoint: CGPoint = CGPoint(x: -500,y: 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animate(withDuration: 0.3,
            animations: {
                self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(card: self)
    }

    func rightClickAction() -> Void {
        let finishPoint = CGPoint(x: 600,y: self.center.y)
        UIView.animate(withDuration: 0.3,
            animations: {
                self.center = finishPoint
                self.transform = CGAffineTransform(rotationAngle: 1)
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedRight(card: self)
    }

    func leftClickAction() -> Void {
        let finishPoint: CGPoint = CGPoint(x: -600,y: self.center.y)
        UIView.animate(withDuration: 0.3,
            animations: {
                self.center = finishPoint
                self.transform = CGAffineTransform(rotationAngle: 1)
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(card: self)
    }
    
    
}
