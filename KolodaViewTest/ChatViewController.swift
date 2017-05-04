//
//  ChatViewController.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 03/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser
    var recipientUser : User?
    var currentChat : Chat?
    var lastId  : Int = 0
    var ref : FIRDatabaseReference!
    var messages : [Message] = []
    var rowHeight : CGFloat? = 0.0

    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.register(ChatTableViewCell.cellNib, forCellReuseIdentifier: ChatTableViewCell.cellIdentifier)
            tableView.register(ChatImageTableViewCell.cellNib, forCellReuseIdentifier: ChatImageTableViewCell.cellIdentifier)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        ref = FIRDatabase.database().reference()
        
//        if let email = currentUser?.email {
//            self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 18)!]
//            if email == currentChat.userEmails[0] {
//                self.navigationItem.title = "\(currentChat.userScreenNames[1])"
//            } else {
//                self.navigationItem.title = "\(currentChat.userScreenNames[0])"
//            }
//        }
        
        
        
        listenToFirebase()


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func listenToFirebase() {
        
        let currentChatID = currentChat?.id
        ref.child("chat").child(currentChatID!).child("messages").observe(.childAdded, with: { (snapshot) in
            guard let info = snapshot.value as? NSDictionary else {return}
            self.addToChat(id: snapshot.key, messageInfo: info)
            self.messages.sort(by: { (message1, message2) -> Bool in
                return message1.id < message2.id
            })
            if let lastMessage = self.messages.last {
                self.lastId = lastMessage.id
            }
            
            self.tableView.reloadData()
            self.tableViewScrollToBottom()
            
        })
        
        ref.child("chat").child((currentChat?.id)!).child("messages").observe(.childRemoved, with: { (snapshot) in
            guard let deletedId = Int(snapshot.key) else {return}
            if let deletedIndex = self.messages.index(where: { (msg) -> Bool in
                return msg.id == deletedId
            }) {
                self.messages.remove(at: deletedIndex)
                let indexPath = IndexPath(row: deletedIndex, section: 0)
                self.tableView.deleteRows(at: [indexPath], with: .right)
            }
            
        })
        
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        let currentDate = NSDate()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        let timeCreated = dateFormatter.string(from: currentDate as Date)
        
        if let userName = currentUser?.email,
            let body = inputTextField.text {
            // write to firebase
            lastId = lastId + 1
            let post : [String : Any] = ["userID": currentUser!.uid, "userEmail": userName, "body": body, "image" : "nil", "timestamp": timeCreated]
            
            ref.child("chat").child((currentChat?.id)!).child("messages").child("\(lastId)").updateChildValues(post)
            
            
            inputTextField.text = ""
        }
        
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func addToChat(id : Any, messageInfo : NSDictionary) {
        
        if let userID = messageInfo["userID"] as? String,
            let userEmail = messageInfo["userEmail"] as? String,
            let body = messageInfo["body"] as? String,
            let imageURL = messageInfo["image"] as? String,
            let messageId = id as? String,
            let timeCreated = messageInfo["timestamp"] as? String,
            let currentMessageId = Int(messageId) {
            let newMessage = Message(anId : currentMessageId, aUserID : userID, aUserEmail : userEmail, aBody : body, anImageURL: imageURL, aDate : timeCreated)
            self.messages.append(newMessage)
            
        }
        
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func dismissImagePicker() {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(_ image: UIImage) {
        
        let ref = FIRStorage.storage().reference()
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        ref.child("\(currentUser?.email)-\(createTimeStamp()).jpeg").put(imageData, metadata: metaData) { (meta, error) in
            
            if let downloadPath = meta?.downloadURL()?.absoluteString {
                //save to firebase database
                self.saveImagePath(downloadPath)
            }
            
        }
        
        
    }
    
    func createTimeStamp() -> String {
        
        let currentDate = NSDate()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        let timeCreated = dateFormatter.string(from: currentDate as Date)
        
        return timeCreated
        
    }
    
    func saveImagePath(_ path: String) {
        lastId = lastId + 1
        
        let chatValue : [String: Any] = ["userID": currentUser!.uid, "userEmail": currentUser!.email!, "body":"\(currentUser!.uid)-\(createTimeStamp())", "timestamp": createTimeStamp(), "image": path]
        
        ref.child("chat").child((currentChat?.id)!).child("messages").child("\(lastId)").updateChildValues(chatValue)
    }
}

extension ChatViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        defer {
            dismissImagePicker()
        }
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        //display / store
        uploadImage(image)
        
    }
    
    func uniqueFileForUser(_ name: String) -> String {
        let currentDate = Date()
        return "\(name)_\(currentDate.timeIntervalSince1970).jpeg"
    }
    
    
    
    
}


extension ChatViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentMessage = messages[indexPath.row]
        
        if currentMessage.imageURL != "nil" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatImageTableViewCell") as? ChatImageTableViewCell else {return UITableViewCell()}
            
            cell.nameLabel.text = recipientUser?.name
            let messageURL = currentMessage.imageURL
            cell.chatImageView.loadImageUsingCacheWithUrlString(messageURL)
            cell.timeSentLabel.text = currentMessage.timestamp
        
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.cellIdentifier, for: indexPath) as? ChatTableViewCell else {return UITableViewCell()}

            cell.nameLabel.text = recipientUser?.name
            cell.timeLabel.text = currentMessage.timestamp
            cell.chatTextView.text = currentMessage.body
            
            return cell
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    let currentMessage = messages[indexPath.row]
        if currentMessage.imageURL != "nil" {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as?
                ImageViewController else { return }
            controller.currentMessage = messages[indexPath.row]
            present(controller, animated: true, completion: nil)
        }
   
    }
    
    
    
    func tableViewScrollToBottom() {
        let numberOfRows = self.tableView.numberOfRows(inSection: 0)
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            
            
            let targetID = self.messages[indexPath.row].id
            
            //remove from database (modified)
            self.ref.child("path").removeValue()
            self.ref.child("chat").child((currentChat?.id)!).child("messages").child("\(targetID)").removeValue()
            
            messages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
        }
    }
   
}


