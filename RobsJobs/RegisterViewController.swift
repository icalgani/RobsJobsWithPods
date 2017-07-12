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
    let userRegisterData = UserRegisterData()
    
    var heightAdjustment: Int = 0
    
    
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
            userRegisterData.doRegisterUserToServer(targetViewController: self, userEmail: EmailTextfield.text!, userPassword: PasswordTextfield.text!, userName: NameTextfield.text!, userMobileNo: PhoneNumberTextfield.text!)
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
        
//        set borderColor
        EmailTextfield.setGrayBorderWithpadding(20)
        RetypeEmailTextfield.setGrayBorderWithpadding(20)
        PhoneNumberTextfield.setGrayBorderWithpadding(20)
        PasswordTextfield.setGrayBorderWithpadding(20)
        RetypePasswordTextfield.setGrayBorderWithpadding(20)
        NameTextfield.setLeftPaddingPoints(20)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //adjust keyboard so you can see what you fill in
    func adjustInsetForKeyboardShow(show: Bool, notification: Notification) {
        print("adjust inset for keyboard")
        guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else {
            return }
        let keyboardFrame = value.cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 100) * (show ? 1 : -1)
        print("adjustment height = \(adjustmentHeight)")
        ScrollView.contentInset.bottom = adjustmentHeight
        ScrollView.scrollIndicatorInsets.bottom = adjustmentHeight
    }
    
    func keyboardWillShow(notification: Notification) {
        print("keyboard will show")
        adjustInsetForKeyboardShow(show: true, notification: notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("keyboard will hide")
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
