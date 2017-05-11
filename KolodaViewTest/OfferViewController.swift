//
//  OfferViewController.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 04/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase

class OfferViewController: UIViewController {
    
    var selectedUser : User?
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.circlerImage()
            imageView.borderColors()
        }
    }
    var currentUser : FIRUser!
    var myUserName : String? = ""
    var currentUserID : String? = ""
    var currentUserImageUrl : String? = ""
    var currentPrice : String? = ""
    var currentLocation : String? = ""
    var currentSubject : String? = ""
    var currentSchedule : String? = ""
    var userList : [User] = []
    var ref : FIRDatabaseReference!
    
    @IBOutlet weak var priceTextField: UITextField!{
        didSet{
            priceTextField.borderColor()
        }
    }
    @IBOutlet weak var locationTextView: UITextView!{
        didSet{
            locationTextView.text = "Where would you like to meetup?"
            locationTextView.layer.borderColor = UIColor.orange.cgColor
            locationTextView.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var subjectTextField: UITextField!{
        didSet{
            subjectTextField.borderColor()
        }
    }
    @IBOutlet weak var scheduleTextField: UITextField!{
        didSet{
            scheduleTextField.borderColor()
        }
    }
    @IBOutlet weak var offerButton: UIButton!{
        didSet{
            offerButton.circlerImage()
            offerButton.layer.borderColor = UIColor.orange.cgColor
            offerButton.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var cancelButton: UIButton!{
        didSet{
            cancelButton.circlerImage()
            cancelButton.layer.borderColor = UIColor.orange.cgColor
            cancelButton.layer.borderWidth = 1.0
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        currentUser = FIRAuth.auth()?.currentUser
        listenToFirebase()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

       @IBAction func locationPlaceHolder(_ sender: Any) {
        if locationTextView.text == "Where would you like to meetup?" {
            locationTextView.text = ""
            locationTextView.textColor = .black
        }
        
    }
    
    
    func checkTextView() {
        if locationTextView.text == "" {
            locationTextView.text = "Where would you like to meetup?"
            locationTextView.textColor = .lightGray
        }
    }
    
    func addAlertAndAction(title: String, message: String, actionTitle: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.destructive, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
        
    }


    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func offerButtonTapped(_ sender: Any) {
        
        setupUpdatedData()
 
    }
    
    func setupUpdatedData() {
        
        if priceTextField.text == "" || locationTextView.text == "" || subjectTextField.text == "" || scheduleTextField.text == "" {
            addAlertAndAction(title: "Missing Fields", message: "kindly fill in the required values", actionTitle: "Ok")
            return
        } else {
            
            self.currentPrice = priceTextField.text
            self.currentLocation = locationTextView.text
            self.currentSubject = subjectTextField.text
            self.currentSchedule = scheduleTextField.text
            
        }
        
        selectedUserFirebase()
        
        
    }
    
    func setupData() {
        priceTextField.text = selectedUser?.price
        locationTextView.text = selectedUser?.location
        subjectTextField.text = selectedUser?.firstSub
        if let profileURL = selectedUser?.profileImageUrl {
            imageView.loadImageUsingCacheWithUrlString(profileURL)
            imageView.circlerImage()
        }
        

    }
    
    func selectedUserFirebase() {
        
        let offer : [String : Any] = ["offeredBy": currentUserID!, "offeredTo" : (selectedUser?.uid)!, "offeresImage": currentUserImageUrl!, "price": currentPrice!, "location" : currentLocation!, "subject" : currentSubject!, "schedule" : currentSchedule!, "name" : (selectedUser?.name)!, "myName" : myUserName!]
        
        FIRDatabase.database().reference().child("offers").childByAutoId().updateChildValues(offer)
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let offeredPage = storyboard.instantiateViewController(withIdentifier: "OfferedViewController") as? OfferedViewController else {return}
        present(offeredPage, animated: true, completion: nil)
        
        
    }
    
    func listenToFirebase() {
        FIRDatabase.database().reference().child("users").child(currentUser.uid).observe(.value, with: { (snapshot) in
            
            let dictionary = snapshot.value as? [String : Any]
            self.currentUserID = dictionary?["uid"] as? String
            self.currentUserImageUrl = dictionary?["profileImageUrl"] as? String
            self.myUserName = dictionary?["name"] as? String
            
        })
    }
   

}
