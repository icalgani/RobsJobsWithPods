//
//  SLPagingSetUp.swift
//  RobsJobs
//
//  Created by MacBook on 6/12/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import Foundation
//
//  Global.swift
//  TinderTest
//
//  Created by David Seek on 10/27/16.
//  Copyright © 2016 David Seek. All rights reserved.
//

import Foundation
import StoreKit
import SLPagingViewSwift_Swift3

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let mainStb = UIStoryboard(name: "test", bundle: nil)
let cachedOrange = UIColor(red: 255/255, green: 69.0/255, blue: 0.0/255, alpha: 1.0)
let cachedGray = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.0)

var controller: SLPagingViewSwift!
var nav: UINavigationController?
var navigationSideItemsStyle: SLNavigationSideItemsStyle!

// VCs
var oneVC: OneVC?
var twoVC: TwoVC?
var threeVC: ThreeVC?

// Items
var chat = UIImage(named: "rj_chat_on")
var gear = UIImage(named: "RJ_login_logo")
var profile = UIImage(named: "rj_profile_on")

// Set VC
func instantiateControllers()  {
    oneVC = mainStb.instantiateViewController(withIdentifier: "OneVC") as? OneVC
    twoVC = mainStb.instantiateViewController(withIdentifier: "TwoVC") as? TwoVC
    threeVC = mainStb.instantiateViewController(withIdentifier: "ThreeVC") as? ThreeVC
}
// Set Items
func setItems() {
    chat = chat?.withRenderingMode(.alwaysTemplate)
    gear = gear?.withRenderingMode(.alwaysTemplate)
    profile = profile?.withRenderingMode(.alwaysTemplate)
}
//---------------------------------------------------------------------------------------
//
// Sets up the Tinder style navigation bar
//
//---------------------------------------------------------------------------------------
func setupController() {
    controller?.pagingViewMovingRedefine = ({ scrollView, subviews in
//        var i = 0
//        var xOffset = scrollView.contentOffset.x
//        for v in subviews {
//            var lbl = v as UILabel
//            var alpha = CGFloat(0)
//            
//            if(lbl.frame.origin.x > 45 && lbl.frame.origin.x < 145) {
//                alpha = 1.0 - (xOffset - (CGFloat(i)*320.0)) / 320.0
//            }
//            else if (lbl.frame.origin.x > 145 && lbl.frame.origin.x < 245) {
//                alpha = (xOffset - (CGFloat(i)*320.0)) / 320.0 + 1.0
//            }
//            else if(lbl.frame.origin.x == 145){
//                alpha = 1.0
//            }
//            lbl.alpha = CGFloat(alpha)
//            i++
//        }
    })}

//---------------------------------------------------------------------------------------
//
// Returns UIColor gradient
//
//---------------------------------------------------------------------------------------
func gradient(_ percent: Double, topX: Double, bottomX: Double, initC: UIColor, goal: UIColor) -> UIColor{
    let t = (percent - bottomX) / (topX - bottomX)
    
    let cgInit = initC.cgColor.components
    let cgGoal = goal.cgColor.components
    
    let r = (cgInit?[0])! + (CGFloat(t)) * ((cgGoal?[0])! - (cgInit?[0])!)
    let g = (cgInit?[1])! + CGFloat(t) * ((cgGoal?[1])! - (cgInit?[1])!)
    let b = (cgInit?[2])! + CGFloat(t) * ((cgGoal?[2])! - (cgInit?[2])!)
    
    return UIColor(red: r, green: g, blue: b, alpha: 1.0)
}

// Sets the root
func setNav() {
    
    
    //// implement my logic (if logged in go to... if not go to...)
    
    instantiateControllers()
//    setItems()
    
    let items = [UIImageView(image: chat),
                 UIImageView(image: gear),
                 UIImageView(image: profile)]
    
    let controllers = [oneVC!,
                       twoVC!,
                       threeVC!] as [UIViewController]
    
    controller = SLPagingViewSwift(items: items, controllers: controllers, showPageControl: false)
    controller.navigationSideItemsStyle = .slNavigationSideItemsStyleOnBounds
    
    setupController()
    
    nav = UINavigationController(rootViewController: controller)
    controller.setCurrentIndex(0, animated: false)
    appDelegate.window?.rootViewController = nav
    appDelegate.window?.makeKeyAndVisible()
}
