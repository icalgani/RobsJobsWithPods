//
//  RegisterViewController.swift
//  RobsJobs
//
//  Created by MacBook on 3/31/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var NameTextfield: UITextField!
    @IBOutlet weak var LastNameTextfield: UITextField!
    @IBOutlet weak var EmailTextfield: UITextField!
    @IBOutlet weak var RetypeEmailTextfield: UITextField!
    @IBOutlet weak var PhoneNumberTextfield: UITextField!
    @IBOutlet weak var PasswordTextfield: UITextField!
    @IBOutlet weak var RetypePasswordTextfield: UITextField!
    @IBOutlet weak var SignUpButton: ButtonCustom!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var NameView: UIView!
    
    @IBOutlet weak var StackName: UIStackView!
    let Utility = UIUtility()
    
    
    @IBAction func RegisterUser(_ sender: UIButton) {
        
        //check if theres empty field
        if (NameTextfield.text=="" || EmailTextfield.text=="" || RetypeEmailTextfield.text=="" || PhoneNumberTextfield.text=="" || PasswordTextfield.text=="" || RetypeEmailTextfield.text==""){
        
            //show alert if there is empty field
            let alertController = UIAlertController(title: "Alert", message:
                "Field must be filled in", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else if(EmailTextfield.text != RetypeEmailTextfield.text){               //check if email and retype email doesnt match
            
            //show alert if email and retype email doesnt match
            let alertController = UIAlertController(title: "Alert", message:
                "Email doesn't match", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else if(PasswordTextfield.text != RetypePasswordTextfield.text){ //check if password and retype password doesnt match
            
            print("Password Textfield = \(String(describing: PasswordTextfield.text)), Retype Password Textfield = \(String(describing: RetypePasswordTextfield.text)) ")
            //show alert if password and retype password doenst match
            let alertController = UIAlertController(title: "Alert", message:
                "Password doesn't match", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            //check login
            var request = URLRequest(url: URL(string: "http://api.robsjobs.co/api/v1/user/signup")!)
            request.httpMethod = "POST"
            let postString = "email=\((EmailTextfield.text)!)&password=\((PasswordTextfield.text)!)&name=\((NameTextfield.text)!) \((LastNameTextfield.text)!)&mobile_no=\((PhoneNumberTextfield.text)!)"
            request.httpBody = postString.data(using: .utf8)
            print(postString)
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
                            DispatchQueue.main.async {
                            //set alert if email or password is wrong
                            let alertController = UIAlertController(title: "Alert", message:
                                currentErrorMessage, preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                            }
                        }else{
                            DispatchQueue.main.async {
                            //tell user that register is success
                            let alertController = UIAlertController(title: "Alert", message:
                                "Registration Success", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                            
                            //go to FirstTimeLogin Storyboard
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "StartingPoint") as! ViewController
                            self.present(nextViewController, animated:true, completion:nil)
                            }
                        }
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                } // end do
                
            }//end request
            task.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NameTextfield.delegate=self
        EmailTextfield.delegate=self
        RetypeEmailTextfield.delegate=self
        PhoneNumberTextfield.delegate=self
        PasswordTextfield.delegate=self
        RetypePasswordTextfield.delegate=self
        // Do any additional setup after loading the view.
        
        //create background
//        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//        backgroundImage.image = UIImage(named: "bg_login")
//        self.view.insertSubview(backgroundImage, at: 0)
        
        //change status bar color
        Utility.setStatusBarBackgroundColor(color: Utility.hexStringToUIColor(hex: "#d3d3d3"))
        
        //add pad bar
        addUIBarPad(textField: PhoneNumberTextfield)
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
//        set email borderColor
        EmailTextfield.setGrayBorderWithpadding(20)
        
        //set email borderColor
        RetypeEmailTextfield.setGrayBorderWithpadding(20)
        
        //set Phone borderColor
        PhoneNumberTextfield.setGrayBorderWithpadding(20)
        
        //set password borderColor
        PasswordTextfield.setGrayBorderWithpadding(20)
        
        //set RetypePasswordTextfield borderColor
        RetypePasswordTextfield.setGrayBorderWithpadding(20)
        
        //set name view borderColor
        NameView.layer.borderWidth = 1
        NameView.layer.borderColor = UIColor.gray.cgColor
        
        NameTextfield.setLeftPaddingPoints(20)
        LastNameTextfield.setLeftPaddingPoints(20)
        
        LastNameTextfield.setLineSeparator(5, lineWidth: 1.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //adjust keyboard so you can see what you fill in
    func adjustInsetForKeyboardShow(show: Bool, notification: Notification) {
        guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1 : -1)
        ScrollView.contentInset.bottom = adjustmentHeight
        ScrollView.scrollIndicatorInsets.bottom = adjustmentHeight
    }
    
    func keyboardWillShow(notification: Notification) {
        adjustInsetForKeyboardShow(show: true, notification: notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        adjustInsetForKeyboardShow(show: false, notification: notification as Notification)
    }
    
    //press next to change to next tab
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        ScrollView.contentInset.bottom = 0
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
    
    
    func addUIBarPad(textField: UITextField){
        let numberToolbar: UIToolbar = UIToolbar()
        
        numberToolbar.barStyle = UIBarStyle.blackTranslucent
        numberToolbar.items=[
            UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.plain, target: self, action: #selector(clearNumfield(textfield:))),
            
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(closeNumpad))
        ]
        
        numberToolbar.sizeToFit()
        
        textField.inputAccessoryView = numberToolbar //do it for every relevant textfield if there are more than one
    }
    
    
    func closeNumpad() {
        PhoneNumberTextfield.resignFirstResponder()
    }
    
    func clearNumfield (textfield: UITextField)
    {
        PhoneNumberTextfield.text = ""
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
