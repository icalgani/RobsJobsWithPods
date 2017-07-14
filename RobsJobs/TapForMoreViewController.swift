//
//  TapForMoreViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/21/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class TapForMoreViewController: UIViewController {
    
    var passedData: String!
    
    var idArray: String!
    var employerIDArray: String!
    var jobTitleArray: String!
    var interestArray: String!
    var employmentTypeArray: String!
    var distanceArray: String!
    var salaryArray: String!
    var endDateArray: String!
    var companyLogoArray: UIImage!
    var experienceArray: String!
    var descriptionArray: String!
    var companyName: String!
    var jobScore: String!
    
    let apiURL = API_ROBSJOBS.api.rawValue

    
    let employerData = EmployerData()
    
    @IBOutlet weak var InfoView: UIView!
    @IBOutlet weak var ContainerVIew: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var ExitButton: UIButton!
    @IBOutlet weak var OkButton: UIButton!
    
    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var TypeLabel: UILabel!
    @IBOutlet weak var SalaryLabel: UILabel!
    @IBOutlet weak var ExperienceLabel: UILabel!
    @IBOutlet weak var CompanyLabel: UILabel!
    
    @IBOutlet weak var JobLabel: UILabel!
    @IBOutlet weak var InterestLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var ExpiredDateLabel: UILabel!
    
    @IBOutlet weak var UserImage: UIImageView!
    
    @IBAction func backToTapForMore(segue: UIStoryboardSegue) {
    }
    
    @IBAction func ApplyButtonPressed(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Core", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SwipingScene") as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.cardIsSwiped(requestType: "apply", jobScoreToSend: jobScore)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "swipeLeft"), object: nil)
        appDelegate.window?.rootViewController = nextViewController
    }
    
    @IBAction func CloseButtonPressed(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Core", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SwipingScene") as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.cardIsSwiped(requestType: "reject", jobScoreToSend: jobScore)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "swipeLeft"), object: nil)        
        appDelegate.window?.rootViewController = nextViewController
    }
    
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Core", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SwipingScene") as! UITabBarController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nextViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.setEmployerName), name:NSNotification.Name(rawValue: "setEmployerName"), object: nil)

        //set background image
        
        DescriptionLabel.text = descriptionArray
//        DescriptionLabel.sizeToFit()
//        DescriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        JobLabel.text = jobTitleArray
        DistanceLabel.text = "\(distanceArray!) Km away"
        TypeLabel.text = employmentTypeArray
        SalaryLabel.text = salaryArray
        ExperienceLabel.text = "\(experienceArray) years of experience"
        UserImage.image = companyLogoArray
        CompanyLabel.text = companyName
        ExpiredDateLabel.text = "\(endDateArray!) days to go"
        
        InfoView.setSettingBoxView()
    }
    
    override func viewDidLayoutSubviews() {
        self.ExitButton.layer.addBorderToSide(edge: UIRectEdge.top, color: UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0), thickness: 1.5)
        self.OkButton.layer.addBorderToSide(edge: UIRectEdge.top, color: UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0), thickness: 1.5)
        self.OkButton.layer.addBorderToSide(edge: UIRectEdge.left, color: UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0), thickness: 1.5)
    }
    
//    func setEmployerName(notification: NSNotification){
//        CompanyLabel.text = employerData.jobEmployer
//    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func cardIsSwiped(requestType: String, jobScoreToSend: String){
        var request = URLRequest(url: URL(string: "\(apiURL)/job/\(requestType)")!)
        let userDefaults = UserDefaults.standard
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        request.httpMethod = "POST"
        
        let postString = "userid=\(String(describing: (userDictionary?["userID"])!))&jobid=\((idArray))&jobscore=\(jobScoreToSend)"
        
        print("post string card is swiped = \(postString)")
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            //handling json
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        //if status code is not 200
                        let errorMessage = json["error"] as! [String:Any]
                        let currentErrorMessage = errorMessage["message"] as! String
                        print("status code: \(httpStatus.statusCode)")
                    }else{
                        let jsonData = json["data"] as! [String:Any]
                    } // if else
                } //if json
            } catch let error {
                print(error.localizedDescription)
            } // end do
            
        } //end task
        task.resume()
    }

}
