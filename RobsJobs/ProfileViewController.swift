//
//  ProfileViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/11/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {

    
    
    @IBOutlet weak var UserDescriptionLabel: UILabel!
    @IBOutlet weak var userSkillsLabel: UILabel!
    
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var BirthdateLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var EducationLabel: UILabel!
    @IBOutlet weak var CharactersLabel: UILabel!
    @IBOutlet weak var SkillsLabel: UILabel!
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var ProfessionLabel: UILabel!
    @IBOutlet weak var CityLabel: UILabel!
    
    @IBOutlet weak var CityView: UIView!
    @IBOutlet weak var ProfessionView: UIView!
    @IBOutlet weak var UserAgeView: UIView!
    
    @IBAction func doLogOut(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userDictionary")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "StartingPoint") as UIViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nextViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshUserImage), name:NSNotification.Name(rawValue: "refreshUserImage"), object: nil)
    }
    
    func refreshUserImage(){
        let userDefaults = UserDefaults.standard
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        if let imageData = userDictionary?["image"] {
            print("user dictionary image = \(userDictionary?["image"] as! String)")
            let checkedUrl = URL(string: imageData as! String)
            downloadImage(url: checkedUrl!)
        }
    }
    
    override func viewDidLayoutSubviews() {
        setUserDescriptionLabel()
        
        // rounding user profile image
        self.UserImage.layer.cornerRadius = self.UserImage.frame.size.width / 2
        self.UserImage.clipsToBounds = true
        //rounding  user age
        self.UserAgeView.layer.cornerRadius = self.UserAgeView.frame.size.width / 2
        self.UserAgeView.clipsToBounds = true
        
        self.ProfessionView.layer.addBorderToSide(edge: UIRectEdge.top, color: UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0), thickness: 1.5)
        self.CityView.layer.addBorderToSide(edge: UIRectEdge.top, color: UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0), thickness: 1.5)
        self.CityView.layer.addBorderToSide(edge: UIRectEdge.left, color: UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0), thickness: 1.5)
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUserDescriptionLabel(){
        let userDefaults = UserDefaults.standard
        let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
        if(userDictionary?["city"] == nil){
            userDefaults.removeObject(forKey: "userDictionary")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "StartingPoint") as UIViewController
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = nextViewController
        } else{
            UserNameLabel.text = userDictionary?["userName"] as? String

            BirthdateLabel.text = (userDictionary?["birthdate"] as? String)
            EmailLabel.text = userDictionary?["email"] as? String
            LocationLabel.text = userDictionary?["city"] as? String
            EducationLabel.text = userDictionary?["edu_level"] as? String
            UserDescriptionLabel.text = userDictionary?["bio"] as? String
            ProfessionLabel.text = userDictionary?["sectors"] as? String
            CityLabel.text = userDictionary?["city"] as? String
            
            
            //download image from url
            if let imageData = userDictionary?["image"] {
                let checkedUrl = URL(string: imageData as! String)
                if(checkedUrl != nil){
                    downloadImage(url: checkedUrl!)
                }
            }
        }
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                self.UserImage.image = UIImage(data: data)
                self.UserImage.layer.cornerRadius = self.UserImage.frame.size.width / 2
                self.UserImage.clipsToBounds = true
                self.UserImage.layer.borderWidth = 2
                self.UserImage.layer.borderColor = UIColor(red:0.70, green:0.87, blue:0.86, alpha:1.0).cgColor
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}
