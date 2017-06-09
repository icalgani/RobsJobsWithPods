//
//  ChatDetailViewController.swift
//  Rob'sJobs
//
//  Created by MacBook on 5/18/17.
//  Copyright © 2017 MacBook. All rights reserved.
//

import UIKit
class ChatDetailCell: UITableViewCell{
    
    @IBOutlet weak var MessageLabel: UILabel!
    @IBOutlet weak var MessageView: UIView!
    var employerMessageConstraint: NSLayoutConstraint?
    var userMessageConstraint: NSLayoutConstraint?
    
    func setConstraintEmployer(){
        MessageView.translatesAutoresizingMaskIntoConstraints = false
        MessageView.backgroundColor = UIColor.white
        MessageLabel.textAlignment = NSTextAlignment.left

        employerMessageConstraint = NSLayoutConstraint(item: MessageView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 10)
        employerMessageConstraint?.isActive = true
        
        if(userMessageConstraint != nil){
            userMessageConstraint?.isActive = false
        }
    }
    
    func setConstraintUser(){
        MessageView.translatesAutoresizingMaskIntoConstraints = false
        MessageView.backgroundColor = UIColor(red:0.69, green:0.87, blue:0.86, alpha:1.0)
        MessageLabel.textAlignment = NSTextAlignment.right
        
        userMessageConstraint = NSLayoutConstraint(item: MessageView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: -10)
        
        userMessageConstraint?.isActive = true
        
        if(employerMessageConstraint != nil){
            employerMessageConstraint?.isActive = false
        }
    }
}

class ChatDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var TableViewOutlet: UITableView!
    
    @IBOutlet weak var MessageTextfield: UITextField!
    @IBOutlet weak var SendMessageButton: UIButton!
    @IBOutlet weak var MessageScrollView: UIScrollView!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var TestCell: UITableViewCell!
    
    @IBOutlet weak var ChatBoxView: UIView!
    @IBOutlet weak var CompanyImageView: UIImageView!
    @IBOutlet weak var CompanyNameLabel: UILabel!
    
    let chatData = ChatData()
    
    var timer : Timer?
    
    var messageArray: [String] = []
    var tempMessageArray: [String] = []
    var userTypeArray: [String] = []
    
    var passedCompanyName: String = "No Info"
    var passedChatGroupID: String = ""
    var passedCompanyImage: UIImage!
    
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func SendButtonPressed(_ sender: UIButton) {
        
        messageArray.append(MessageTextfield.text!)
        userTypeArray.append("user")
        self.TableViewOutlet.reloadData()

        chatData.postMessageData(jobAppId: passedChatGroupID, message: MessageTextfield.text!)

        MessageTextfield.text = ""
        
        let bottomIndexPath = IndexPath(row: self.messageArray.count - 1, section: 0)
        TableViewOutlet.scrollToRow(at: bottomIndexPath, at: .bottom,
                                    animated: true)
        
        MessageTextfield.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableViewOutlet.rowHeight = UITableViewAutomaticDimension
        TableViewOutlet.estimatedRowHeight = 100
        
        getData()
        
        MessageTextfield.delegate = self
        
        CompanyNameLabel.text = passedCompanyName
        CompanyImageView.image = passedCompanyImage
        CompanyImageView.layer.cornerRadius = CompanyImageView.frame.size.width / 2
        CompanyImageView.clipsToBounds = true
        ChatBoxView.layer.shadowRadius = 2
        ChatBoxView.layer.shadowOpacity = 0.6
        ChatBoxView.layer.shadowOffset = CGSize(width: 1,height:1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadChatData), name:NSNotification.Name(rawValue: "loadChatData"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardMessageWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardMessageWillHide(notification:)),name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        timer = Timer.scheduledTimer(timeInterval: 5,
                             target: self,
                             selector: #selector(self.getData),
                             userInfo: nil,
                             repeats: true)
        
    }
    
    func getData(){
        chatData.getDataFromServer(dataToGet:"\(passedChatGroupID)/0/15")
    }
    
    func loadChatData(){
        if(tempMessageArray.count == 0){        //if this is the first time loading the data
            showChatData()
        }else{
            if(tempMessageArray == chatData.messageToSend.reversed()){      //if the data refreshed is the same as previous data
                
                
            }else{
                showChatData()
            }
        }
        
    }
    
    func showChatData(){
        messageArray.removeAll()
        userTypeArray.removeAll()
        messageArray = chatData.messageToSend.reversed()
        userTypeArray = chatData.userTypeToSend.reversed()
        tempMessageArray = messageArray
        self.TableViewOutlet.reloadData()
        let bottomIndexPath = IndexPath(row: self.messageArray.count - 1, section: 0)
        TableViewOutlet.scrollToRow(at: bottomIndexPath, at: .bottom,
                                    animated: true)
    }
    
    //adjust keyboard so you can see what you fill in
    func adjustInsetForKeyboardShow(show: Bool, notification: Notification) {
        print("adjust inset for keyboard show")
        guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let adjustmentHeight = (keyboardFrame.height) * (show ? 1 : -1)
        print("adjustment keyboard height = \(adjustmentHeight)")
        MessageScrollView.contentInset.bottom = adjustmentHeight
        MessageScrollView.scrollIndicatorInsets.bottom = adjustmentHeight
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardMessageWillShow(notification: Notification) {
        adjustInsetForKeyboardShow(show: true, notification: notification)
    }
    
    func keyboardMessageWillHide(notification: NSNotification) {
        adjustInsetForKeyboardShow(show: false, notification: notification as Notification)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(messageArray.count)
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath) as! ChatDetailCell
        
        cell.MessageLabel?.text = messageArray[indexPath.row]
        print("message = \(messageArray[indexPath.row]) & usertype = \(userTypeArray[indexPath.row])")
        if(userTypeArray[indexPath.row] == "employer"){
            cell.setConstraintEmployer()
        }else{
            cell.setConstraintUser()
        }
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
}
