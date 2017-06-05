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
    var docPickedTag = 0
    var path : URL!
    var documentID: [String] = []
    var documentType: [String] = []
    var documentPath: [String] = []
    var documentIsPicked: [Bool] = [false,false,false]

    let documentData = DocumentData()
    
    @IBAction func DoneButtonPressed(_ sender: UIButton) {
        
        documentData.uploadPictureRequest(userImage: self.UserPhotoIcon.image!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.pickUserImage(sender:)))
        UserPicture.addGestureRecognizer(gesture)
        
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector (self.pickUserImage1(sender:)))
        Certificate1.isUserInteractionEnabled = true
        Certificate1.addGestureRecognizer(gesture1)

        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector (self.pickUserImage2(sender:)))
        Certificate2.isUserInteractionEnabled = true
        Certificate2.addGestureRecognizer(gesture2)
        
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector (self.pickUserImage3(sender:)))
        Certificate3.isUserInteractionEnabled = true
        Certificate3.addGestureRecognizer(gesture3)
        
        documentData.getDocumentDataFromServer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadDocument), name:NSNotification.Name(rawValue: "loadDocument"), object: nil)
    }
    
    func loadDocument(){
        documentID = documentData.documentIDToSend
        documentType = documentData.documentTypeToSend
        documentPath = documentData.documentPathToSend
        documentIsPicked = documentData.documentIsPickedToSend
    }
    
    func pickUserImage(sender : UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        

        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickUserImage1(sender : UITapGestureRecognizer) {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeVideo), String(kUTTypePlainText), String(kUTTypeMP3)], in: .import)
        documentPickerController.delegate = self

        docPickedTag = 0

        present(documentPickerController, animated: true, completion: nil)

    }
    
    func pickUserImage2(sender : UITapGestureRecognizer) {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeVideo), String(kUTTypePlainText), String(kUTTypeMP3)], in: .import)
        documentPickerController.delegate = self

        docPickedTag = 1
        
        present(documentPickerController, animated: true, completion: nil)

    }
    
    func pickUserImage3(sender : UITapGestureRecognizer) {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeVideo), String(kUTTypePlainText), String(kUTTypeMP3)], in: .import)
        documentPickerController.delegate = self
        
        docPickedTag = 2

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
    
}


extension UploadDocViewController: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
     documentData.uploadDocumentRequest(documentURL: url)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("this is documentpicker")
    }
}
