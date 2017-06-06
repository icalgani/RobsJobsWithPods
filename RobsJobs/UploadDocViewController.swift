//
//  UploadDocViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/9/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices
import Photos
import Alamofire

class UploadDocViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var UserPicture: UIView!
    @IBOutlet weak var UserPhotoIcon: UIImageView!
    @IBOutlet weak var Certificate1: UIImageView!
    @IBOutlet weak var Certificate2: UIImageView!
    @IBOutlet weak var Certificate3: UIImageView!
    @IBOutlet weak var PortfolioTextfield: UITextField!
    
    let imagePicker = UIImagePickerController()
    let userDefaults = UserDefaults.standard

    var docPickedTag = 0
    var documentID: [String] = ["","",""]
    var documentType: [String] = ["","",""]
    var documentPath: [String] = ["","",""]
    var documentURL: [URL?] = [URL(string: ""),URL(string: ""),URL(string: "")]
    var documentIsPicked: [Bool] = [false,false,false]
    
    let documentData = DocumentData()
    
    @IBAction func DoneButtonPressed(_ sender: UIButton) {
        
        var userDictionary = self.userDefaults.value(forKey: "userDictionary") as? [String: Any]
        documentData.uploadPictureRequest(userImage: self.UserPhotoIcon.image!)
        
        for index in 0...(self.documentIsPicked.count - 1){
            if (documentIsPicked[index] && documentID[index] == ""){
                documentData.uploadDocumentRequest(documentURL: documentURL[index]!, documentType: documentType[index])
            }
        }
        
        if(PortfolioTextfield.text != "" || PortfolioTextfield.text != nil){
            userDictionary?["portofolio"] = PortfolioTextfield.text!
            print("portfolio = \(userDictionary?["portofolio"]! as! String)")
            
            userDefaults.set(userDictionary, forKey: "userDictionary")
            
            let sendJson = SendJsonSetupProfile()
            sendJson.sendDataToAPI(userDictionary: userDictionary!)
        }
        // go to core scene
        let storyBoard : UIStoryboard = UIStoryboard(name: "Core", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SwipingScene") as! UITabBarController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nextViewController
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector (self.pickUserImage(sender:)))
        UserPicture.addGestureRecognizer(gesture)
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector (self.pickUserImage1(sender:)))
        Certificate1.isUserInteractionEnabled = true
        Certificate1.addGestureRecognizer(gesture1)

        let gesture2 = UITapGestureRecognizer(target: self, action: #selector (self.pickUserImage2(sender:)))
        Certificate2.isUserInteractionEnabled = true
        Certificate2.addGestureRecognizer(gesture2)
        
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector (self.pickUserImage3(sender:)))
        Certificate3.isUserInteractionEnabled = true
        Certificate3.addGestureRecognizer(gesture3)
        
        var userDictionary = self.userDefaults.value(forKey: "userDictionary") as? [String: Any]
        
        if(userDictionary?["portofolio"] != nil){
            PortfolioTextfield.text = userDictionary?["portofolio"] as? String
        }
        
        if let imageData = userDictionary?["image"] {
            print("user dictionary image = \(userDictionary?["image"] as! String)")
            let checkedUrl = URL(string: imageData as! String)
            downloadImage(url: checkedUrl!)
        }
        
        documentData.getDocumentDataFromServer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadDocument), name:NSNotification.Name(rawValue: "loadDocument"), object: nil)
    }
    
    func loadDocument(){
        print("loadDocument function")

        documentID = documentData.documentIDToSend
        documentType = documentData.documentTypeToSend
        documentPath = documentData.documentPathToSend
        documentIsPicked = documentData.documentIsPickedToSend
        
        self.updateDocumentView()
    }
    
    func pickUserImage(sender : UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickUserImage1(sender : UITapGestureRecognizer) {
        docPickedTag = 0
        
        checkIsDocumentPicked()
    }
    
    func pickUserImage2(sender : UITapGestureRecognizer) {
        docPickedTag = 1
        
        checkIsDocumentPicked()
    }
    
    func pickUserImage3(sender : UITapGestureRecognizer) {
        docPickedTag = 2
        
        checkIsDocumentPicked()
    }
    
    func checkIsDocumentPicked(){
        
        if(documentIsPicked[docPickedTag]){
            showDeletePopup()
        }else{
            showDocumentTypePopup()
        }
    }
    
    func startDocumentPicker(){
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeVideo), String(kUTTypePlainText), String(kUTTypeMP3)], in: .import)
        documentPickerController.delegate = self
        present(documentPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            UIGraphicsBeginImageContext(self.UserPicture.frame.size)
            pickedImage.draw(in: self.UserPicture.bounds)
            
            self.UserPhotoIcon.image = pickedImage
            self.UserPhotoIcon.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint(item: self.UserPhotoIcon,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: self.UserPicture,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 0).isActive = true
            
            NSLayoutConstraint(item: self.UserPhotoIcon,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: self.UserPicture,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 0).isActive = true
            
            NSLayoutConstraint(item: self.UserPhotoIcon,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: self.UserPicture,
                               attribute: .leading,
                               multiplier: 1.0,
                               constant: 0).isActive = true
            
            NSLayoutConstraint(item: self.UserPhotoIcon,
                               attribute: .trailing,
                               relatedBy: .equal,
                               toItem: self.UserPicture,
                               attribute: .trailing,
                               multiplier: 1.0,
                               constant: 0).isActive = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        
        // rounding user profile image
        self.UserPicture.roundingUIView()
        
        //set padding to placeholder
        self.PortfolioTextfield.setLeftPaddingPoints(20.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDocumentView(){
        for index in 0...2 {
            if (documentIsPicked[index]){
                switch index {
                case 0:
                    self.Certificate1.image = UIImage(named: "rj_attach_icon")
                case 1:
                    self.Certificate2.image = UIImage(named: "rj_attach_icon")
                case 2:
                    self.Certificate3.image = UIImage(named: "rj_attach_icon")

                default:
                    return
                }
            }else{
                switch index {
                case 0:
                    self.Certificate1.image = UIImage(named: "RJ_addfile_icon")
                case 1:
                    self.Certificate2.image = UIImage(named: "RJ_addfile_icon")
                case 2:
                    self.Certificate3.image = UIImage(named: "RJ_addfile_icon")
                    
                default:
                    return
                }
            }
        }
    }
    
    func showDeletePopup(){
        // Create the alert controller
        let alertController = UIAlertController(title: "Delete Document", message: "Are you sure you want to delete this document?", preferredStyle: .alert)
        
        // Create the actions
        // delete action
        let okAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            if (self.documentID[self.docPickedTag] != ""){
                self.documentData.deleteDocumentFromServer(docIdToDelete: self.documentID[self.docPickedTag])
            }
            self.documentIsPicked[self.docPickedTag] = false
            self.documentURL[self.docPickedTag] = URL(string: "")
            self.documentID[self.docPickedTag] = ""
            self.documentPath[self.docPickedTag] = ""
            self.updateDocumentView()
        }
        //cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    //show Document picker popup
    func showDocumentTypePopup(){
        // Create the alert controller
        let documentTypeAlertController = UIAlertController(title: "Document Type", message: "Pick Document Type", preferredStyle: .alert)
        
        // Create the actions
        // pick certificate action
        let certificateAction = UIAlertAction(title: "Certificate", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.documentType[self.docPickedTag] = "1"
            self.startDocumentPicker()

        }
        
        //pick document action
        let documentAction = UIAlertAction(title: "Document", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("documentType in \(self.docPickedTag) is \(self.documentType)")
            self.documentType[self.docPickedTag] = "2"
            self.startDocumentPicker()
        }
        
        // Add the actions
        documentTypeAlertController.addAction(certificateAction)
        documentTypeAlertController.addAction(documentAction)
        
        // Present the controller
        self.present(documentTypeAlertController, animated: true, completion: nil)
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                self.UserPhotoIcon.image = UIImage(data: data)
                self.UserPhotoIcon.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint(item: self.UserPhotoIcon,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: self.UserPicture,
                                   attribute: .top,
                                   multiplier: 1.0,
                                   constant: 0).isActive = true
                
                NSLayoutConstraint(item: self.UserPhotoIcon,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: self.UserPicture,
                                   attribute: .bottom,
                                   multiplier: 1.0,
                                   constant: 0).isActive = true
                
                NSLayoutConstraint(item: self.UserPhotoIcon,
                                   attribute: .leading,
                                   relatedBy: .equal,
                                   toItem: self.UserPicture,
                                   attribute: .leading,
                                   multiplier: 1.0,
                                   constant: 0).isActive = true
                
                NSLayoutConstraint(item: self.UserPhotoIcon,
                                   attribute: .trailing,
                                   relatedBy: .equal,
                                   toItem: self.UserPicture,
                                   attribute: .trailing,
                                   multiplier: 1.0,
                                   constant: 0).isActive = true
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


extension UploadDocViewController: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
       print(docPickedTag)
        documentIsPicked[docPickedTag] = true
        documentURL[docPickedTag] = url
        documentPath[docPickedTag] = url.absoluteString
        updateDocumentView()
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("this is documentpicker")
        documentIsPicked[docPickedTag] = false
        
        documentURL[docPickedTag] = URL(string: "")
        documentPath[docPickedTag] = ""
        updateDocumentView()
    }
}
