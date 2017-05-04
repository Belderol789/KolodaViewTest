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
    var currentUserName : String? = ""
    var currentUserImageUrl : String? = ""
    var currentPrice : String? = ""
    var currentLocation : String? = ""
    var currentSubject : String? = ""
    var currentSchedule : String? = ""
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var scheduleTextField: UITextField!
    @IBOutlet weak var offerButton: UIButton!{
        didSet{
            offerButton.circlerImage()
        }
    }
    @IBOutlet weak var cancelButton: UIButton!{
        didSet{
            cancelButton.circlerImage()
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
        
        let offerID = (selectedUser?.uid)!
        
        let offer : [String : Any] = ["offeredBy": currentUserName ?? "Anonymous", "offeredTo" : selectedUser?.name ?? "Anonymous", "offeresImage": currentUserImageUrl ?? "defaultImage", "price": currentPrice!, "location" : currentLocation!, "subject" : currentSubject!, "schedule" : currentSchedule!, "status": "nil"]
        
        FIRDatabase.database().reference().child("offers").child(offerID).updateChildValues(offer)
        
        
        
    }
    
    func listenToFirebase() {
        FIRDatabase.database().reference().child("users").child(currentUser.uid).observe(.value, with: { (snapshot) in
            
            let dictionary = snapshot.value as? [String : Any]
            self.currentUserName = dictionary?["name"] as? String
            self.currentUserImageUrl = dictionary?["profileImageUrl"] as? String
            
        })
    }
   

}
