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
    
    var selectedProfile : User!
    var otherUserID : String = ""
    var profileImage : String? = ""
    var profileEmail : String? = ""
    var profileFirstSub : String? = ""
    var profileSecondSub : String? = ""
    var profileThirdSub : String? = ""
    var offerButtonCenter : CGPoint!
    var messageButtonCenter : CGPoint!
    var reviewButtonCenter : CGPoint!
    var backButtonCenter : CGPoint!
    var currentUserEmail: String! = ""
    var currentUserID: String? = ""
    var currentUserName : String? = ""
    var currentUserImage : String? = ""
    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser

  
    

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.circlerImage()
        }
    }
    @IBOutlet weak var profileView: UIView!{
        didSet{
            profileView.layer.borderColor = UIColor.orange.cgColor
            profileView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var moreButton: UIButton!{
        didSet{
            moreButton.circlerImage()
            moreButton.borderColors()
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
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!{
        didSet{
            
            descTextView.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!{
        didSet{
            reviewButton.circlerImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUserID = FIRAuth.auth()?.currentUser?.uid
        
        listenToFireBase()
        messageButtonCenter = messageButton.center
        offerButtonCenter = offerButton.center
        backButtonCenter = backButton.center
        reviewButtonCenter = reviewButton.center
        
        
        setupAnimation()

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setupAnimation() {
        offerButton.center = moreButton.center
        messageButton.center = moreButton.center
        backButton.center = moreButton.center
        reviewButton.center = moreButton.center
    }
    
    func listenToFireBase() {
        FIRDatabase.database().reference().child("users").child(otherUserID).observe(.value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String : Any]
            
            self.nameLabel.text = dictionary?["name"] as? String
            self.ageLabel.text = dictionary?["age"] as? String
            self.descTextView.text = dictionary?["desc"] as? String
            self.profileImage = dictionary?["profileImageUrl"] as? String
            self.genderLabel.text = dictionary?["gender"] as? String
            self.priceLabel.text = dictionary?["price"] as? String
            self.locationLabel.text = dictionary?["location"] as? String
            self.profileEmail = dictionary?["email"] as? String
            self.firstLabel.text = dictionary?["subject"] as? String
            self.secondLabel.text = dictionary?["secondSubject"] as? String
            self.thirdLabel.text = dictionary?["thirdSubject"] as? String
            
            
            
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
                self.backButton.center = self.backButtonCenter
                self.reviewButton.center = self.reviewButtonCenter
            })
        } else {
            moreButton.setBackgroundImage(#imageLiteral(resourceName: "moreButton"), for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.messageButton.center = self.moreButton.center
                self.offerButton.center = self.moreButton.center
                self.backButton.center = self.moreButton.center
                self.reviewButton.center = self.moreButton.center
            })
        }
    }
    
    @IBAction func offerClicked(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "OfferViewController") as? OfferViewController else {return}
        controller.selectedUser = self.selectedProfile
        present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func reviewsClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let reviewsVC = storyboard.instantiateViewController(withIdentifier: "ReviewListViewController") as! ReviewListViewController
        reviewsVC.currentUserID = self.otherUserID
        reviewsVC.reviewedUser = self.selectedProfile
        
        present(reviewsVC, animated: true, completion: nil)
        
        
        
    }
 
    
    @IBAction func chatClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        
        var userIDs = [currentUserID, otherUserID]
        userIDs.sort { (user1, user2) -> Bool in
            return user1! < user2!
        }
        let chatID = userIDs[0]! + userIDs[1]!
        
        let newChat = Chat(anId: chatID, userOneId: currentUserID!, userOneEmail: currentUserEmail, userOneScreenName: currentUserName!, userOneImageURL: currentUserImage!, userTwoId: otherUserID, userTwoEmail: profileEmail!, userTwoScreenName: self.nameLabel.text!, userTwoImageURL: profileImage!)
        
        let newChatID = newChat.id
        
        FIRDatabase.database().reference().child("chat").child(newChatID).observe(.value, with: { (snapshot) in
            
            if !snapshot.hasChildren() {
                let currentDate = NSDate()
                let dateFormatter:DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd HH:mm"
                let timeCreated = dateFormatter.string(from: currentDate as Date)
                
                let post : [String : Any] = ["messages": ["0": ["body": "This is the beginning of the chat between \((self.selectedProfile!.email)!) and \((self.currentUserEmail)!)", "image" : "nil", "timestamp": timeCreated, "userID": self.currentUserID, "userEmail": self.currentUserEmail]]]
                
                  FIRDatabase.database().reference().child("chat").child(newChat.id).updateChildValues(post)
            }
  
        })
        
        guard let controller = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as?
            ChatViewController else { return }
        controller.recipientUser = self.selectedProfile
        controller.currentChat = newChat
        present(controller, animated: true, completion: nil)
        
    }
    
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }


}
