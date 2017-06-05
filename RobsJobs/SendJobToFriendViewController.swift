//
//  SendJobToFriendViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 4/28/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class SendJobToFriendViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var NameTextfield: FloatLabelWithBlackUnderline!
    @IBOutlet weak var EmailTextfield: FloatLabelWithBlackUnderline!
    @IBOutlet weak var PhoneTextfield: FloatLabelWithBlackUnderline!
    
    var passedJobId: String = ""
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        if(NameTextfield.text == ""){
            let alertController = UIAlertController(title: "Alert", message:
                "Name is required", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else if(EmailTextfield.text == ""){
            let alertController = UIAlertController(title: "Alert", message:
                "Email is required", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else if(PhoneTextfield.text == ""){
            let alertController = UIAlertController(title: "Alert", message:
                "Phone number is required", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            let userDefaults = UserDefaults.standard
            let userDictionary = userDefaults.value(forKey: "userDictionary") as? [String: Any]
            
            var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/job/share")!)
            
            request.httpMethod = "POST"
            let postString = "userid=\((userDictionary?["userID"] as! Int))&jobid=\(passedJobId)&name=\((NameTextfield.text)!)&email=\((EmailTextfield.text)!)&telp=\((PhoneTextfield.text)!)"
            
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                //handling json
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                            //if status code is not 200
                            print("status code: \(httpStatus.statusCode)")
                            print(postString)
                        }else{
                            let jsonData = (json["data"]) as! [String:Any]
                           print(jsonData)
                            
                            DispatchQueue.main.async {
                                
                                let alertController = UIAlertController(title: "Alert", message:
                                    "Success", preferredStyle: UIAlertControllerStyle.alert)
                                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                                
                                self.present(alertController, animated: true, completion: nil)
                                    
                                    //go to Job Swiping Scene
                                    let storyBoard : UIStoryboard = UIStoryboard(name: "Core", bundle: nil)
                                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SwipingScene") as UIViewController
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.window?.rootViewController = nextViewController
                                
                            }
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SendButton.layer.cornerRadius = 5
        
        NameTextfield.delegate = self
        EmailTextfield.delegate = self
        PhoneTextfield.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

}
