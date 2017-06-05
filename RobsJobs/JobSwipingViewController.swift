//
//  JobSwipingViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/12/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class JobSwipingViewController: UIViewController,CLLocationManagerDelegate, UITabBarControllerDelegate {

    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var idArray: String!
    var employerIDArray: String!
    var jobTitleArray: String!
    var interestArray: String!
    var employmentTypeArray: String!
    var distanceArray: String!
    var salaryArray: String!
    var endDateArray: String!
    var companyLogoArray: String!
    var experienceArray: String!
    var descriptionArray: String!
    
    @IBOutlet weak var SuperView: UIView!
    @IBAction func backToJobSwiping(segue: UIStoryboardSegue) {
    }
    
    @IBOutlet weak var MoreButton: UIButton!
    
    @IBAction func MoreButtonPressed(_ sender: UIButton) {
        print("setting button is pressed")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Core", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SettingProfile") as UIViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nextViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        //
        self.tabBarController?.delegate = self
        checkLocationIsOn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            //do your stuff
        }
    }
    
    func checkLocationIsOn(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            currentLocation = locationManager.location
            print("lat long = \(currentLocation?.coordinate.latitude)/\(currentLocation?.coordinate.longitude)")
            let draggableBackground: DraggableViewBackground = DraggableViewBackground(frame: self.view.frame)
            self.view.addSubview(draggableBackground)
        }else{
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
                UIApplication.shared.open(settingsURL)
            }
        }
    }
    
    func doTapForMore(jobTitle: String, interest: String, employmentType: String, distance: String, salary: String, endDate: String, companyLogo: UIImage, experience: String, descriptionJob: String, idJob: String, employerID: String, companyName: String){
        print("inside doTapForMore ")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Core", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TapForMore") as! TapForMoreViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        nextViewController.jobTitleArray = jobTitle
        nextViewController.interestArray = interest
        nextViewController.employmentTypeArray = employmentType
        nextViewController.distanceArray = distance
        nextViewController.salaryArray = salary
        nextViewController.endDateArray = endDate
        nextViewController.companyLogoArray = companyLogo
        nextViewController.experienceArray = experience
        nextViewController.descriptionArray = descriptionJob
        nextViewController.idArray = idJob
        nextViewController.employerIDArray = employerID
        nextViewController.companyName = companyName
        appDelegate.window?.rootViewController = nextViewController
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
