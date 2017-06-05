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
    
    func setConstraintEmployer(){
        MessageView.translatesAutoresizingMaskIntoConstraints = false
        MessageView.backgroundColor = UIColor.white
        MessageLabel.textAlignment = NSTextAlignment.left

        NSLayoutConstraint(item: MessageView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 10).isActive = true
    }
    
    func setConstraintUser(){
        MessageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: MessageView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: -10).isActive = true
    }
}

class ChatDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var TableViewOutlet: UITableView!
    
    @IBOutlet weak var MessageTextfield: UITextField!
    @IBOutlet weak var SendMessageButton: UIButton!
    @IBOutlet weak var MessageScrollView: UIScrollView!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var TestCell: UITableViewCell!
    
    @IBOutlet weak var CompanyImageView: UIImageView!
    @IBOutlet weak var CompanyNameLabel: UILabel!
    
    let chatData = ChatData()
    
    var timer : Timer?
    
    var messageArray: [String] = []
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

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadChatData), name:NSNotification.Name(rawValue: "loadChatData"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        timer = Timer.scheduledTimer(timeInterval: 3,
                             target: self,
                             selector: #selector(self.getData),
                             userInfo: nil,
                             repeats: true)
    }
    
    func getData(){
        messageArray.removeAll()
        userTypeArray.removeAll()
        chatData.getDataFromServer(dataToGet:"\(passedChatGroupID)/0/5")
    }
    
    func loadChatData(){
        messageArray = chatData.messageToSend.reversed()
        userTypeArray = chatData.userTypeToSend.reversed()
        self.TableViewOutlet.reloadData()
    }
    
    //adjust keyboard so you can see what you fill in
    func adjustInsetForKeyboardShow(show: Bool, notification: Notification) {
        guard let value = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1 : -1)
        MessageScrollView.contentInset.bottom = adjustmentHeight
        MessageScrollView.scrollIndicatorInsets.bottom = adjustmentHeight
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: Notification) {
        adjustInsetForKeyboardShow(show: true, notification: notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        adjustInsetForKeyboardShow(show: false, notification: notification as Notification)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath) as! ChatDetailCell
        
        cell.MessageLabel?.text = messageArray[indexPath.row]
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
