//
//  UserViewController.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 03/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase

class UserViewController: UIViewController {
    
    var selectedProfile : User?
    var otherUserID : String = ""
    var profileName : String? = ""
    var profileLocation : String? = ""
    var profilePrice : String? = ""
    var profileAge : String? = ""
    var profileGender : String? = ""
    var profileDesc : String? = ""
    var profileImage : String? = ""
    var profileEmail : String? = ""
    var offerButtonCenter : CGPoint!
    var messageButtonCenter : CGPoint!
    var saveButtonCenter : CGPoint!
    var backButtonCenter : CGPoint!
    var currentUserEmail: String? = ""
    var currentUserID: String? = ""
    var currentUserName : String? = ""
    var currentUserImage : String? = ""
    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser
    //var profileScreenName: String = ""
   // var profileImageURL: String = ""
    
  
    

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.circlerImage()
            imageView.borderColors()
        }
    }
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var stackView: UIStackView! {
        didSet {
            stackView.layer.borderColor = UIColor.orange.cgColor
            stackView.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var moreButton: UIButton!{
        didSet{
            moreButton.circlerImage()
            moreButton.borderColors()
        }
    }
    @IBOutlet weak var saveButton: UIButton!{
        didSet {
            saveButton.circlerImage()
            saveButton.borderColors()
        }
    }
    @IBOutlet weak var messageButton: UIButton!{
        didSet{
            messageButton.circlerImage()
            messageButton.borderColors()
        }
    }
    @IBOutlet weak var offerButton: UIButton!{
        didSet{
            offerButton.circlerImage()
            offerButton.borderColors()
        }
    }
    @IBOutlet weak var backButton: UIButton!{
        didSet{
            backButton.circlerImage()
            backButton.borderColors()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet{
            nameLabel.curveEdges()
        }
    }
    @IBOutlet weak var locationLabel: UILabel! {
        didSet {
            locationLabel.curveEdges()
        }
    }
    @IBOutlet weak var priceLabel: UILabel!{
        didSet {
            priceLabel.curveEdges()
        }
    }
    @IBOutlet weak var ageLabel: UILabel! {
        didSet {
            ageLabel.borderColor()
        }
    }
    @IBOutlet weak var genderLabel: UILabel! {
        didSet {
            genderLabel.borderColor()
        }
    }
    @IBOutlet weak var descTextView: UITextView! {
        didSet {
            descTextView.layer.borderWidth = 1.0
            descTextView.layer.borderColor = UIColor.orange.cgColor
        }
    }
    
    @IBOutlet weak var firstLabel: UILabel!{
        didSet{
            firstLabel.borderColor()
        }
    }
    @IBOutlet weak var secondLabel: UILabel!{
        didSet{
            secondLabel.borderColor()
        }
    }
    @IBOutlet weak var thirdLabel: UILabel!{
        didSet{
            thirdLabel.borderColor()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUserID = FIRAuth.auth()?.currentUser?.uid
        
        
        listenToFireBase()
        messageButtonCenter = messageButton.center
        saveButtonCenter = saveButton.center
        offerButtonCenter = offerButton.center
        backButtonCenter = backButton.center
        
        
        setupAnimation()

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setupAnimation() {
        offerButton.center = moreButton.center
        messageButton.center = moreButton.center
        saveButton.center = moreButton.center
        backButton.center = moreButton.center
    }
    
    func listenToFireBase() {
        FIRDatabase.database().reference().child("users").child(otherUserID).observe(.value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String : Any]
            
            self.profileName = dictionary?["name"] as? String
            self.profileAge = dictionary?["age"] as? String
            self.profileDesc = dictionary?["desc"] as? String
            self.profileImage = dictionary?["profileImageUrl"] as? String
            self.profileGender = dictionary?["gender"] as? String
            self.profilePrice = dictionary?["price"] as? String
            self.profileLocation = dictionary?["location"] as? String
            self.profileEmail = dictionary?["email"] as? String
            
            
            self.setUpProfile()
            self.listenToMyFirebase()
  
            
            
        })
    }
    
    func listenToMyFirebase() {
        FIRDatabase.database().reference().child("users").child(currentUserID!).observe(.value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String : Any]
            
            self.currentUserEmail = dictionary?["email"] as? String
            self.currentUserName = dictionary?["name"] as? String
            self.currentUserImage = dictionary?["profileImageUrl"] as? String
            
            
            
        })
    }
    
    func setUpProfile() {
        
        
        nameLabel.text = profileName
        descTextView.text = profileDesc
        ageLabel.text = profileAge
        locationLabel.text = profileLocation
        genderLabel.text = profileGender
        priceLabel.text = profilePrice
        
        
        if let profileURL = profileImage {
            imageView.loadImageUsingCacheWithUrlString(profileURL)
            imageView.circlerImage()
        }
        
    }
    
   
    @IBAction func moreClicked(_ sender: UIButton) {
        
        if moreButton.currentBackgroundImage == #imageLiteral(resourceName: "moreButton") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "moreButtonOff"), for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.messageButton.center = self.messageButtonCenter
                self.offerButton.center = self.offerButtonCenter
                self.saveButton.center = self.saveButtonCenter
                self.backButton.center = self.backButtonCenter
            })
        } else {
            moreButton.setBackgroundImage(#imageLiteral(resourceName: "moreButton"), for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.messageButton.center = self.moreButton.center
                self.saveButton.center = self.moreButton.center
                self.offerButton.center = self.moreButton.center
                self.backButton.center = self.moreButton.center
            })
        }
    }
    
    @IBAction func offerClicked(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "OfferViewController") as? OfferViewController else {return}
        controller.selectedUser = self.selectedProfile
        present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func chatClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
       
      
        

        
        
        let chatID = currentUserID! + otherUserID
        
        let newChat = Chat(anId: chatID, userOneId: currentUserID!, userOneEmail: currentUserEmail!, userOneScreenName: currentUserName!, userOneImageURL: currentUserImage!, userTwoId: otherUserID, userTwoEmail: profileEmail!, userTwoScreenName: profileName!, userTwoImageURL: profileImage!)
        
        let newChatID = newChat.id
        
        FIRDatabase.database().reference().child("chat").child(newChatID).observe(.value, with: { (snapshot) in
            
            if !snapshot.hasChildren() {
                let currentDate = NSDate()
                let dateFormatter:DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd HH:mm"
                let timeCreated = dateFormatter.string(from: currentDate as Date)
                
                let post : [String : Any] = ["messages": ["0": ["body": "This is the beginning of the chat between \(self.selectedProfile!.email) and \(self.currentUserEmail)", "image" : "nil", "timestamp": timeCreated, "userID": self.currentUserID, "userEmail": self.currentUserEmail]]]
                
                //, "users": [self.currentUserID: self.currentUserEmail, selectedProfile!.uid: selectedProfile!.email]]
                  FIRDatabase.database().reference().child("chat").child(newChat.id).updateChildValues(post)
            }
            
           
           
        })
        
        guard let controller = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as?
            ChatViewController else { return }
        controller.recipientUser = self.selectedProfile
        controller.currentChat = newChat
        present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func saveClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }


}