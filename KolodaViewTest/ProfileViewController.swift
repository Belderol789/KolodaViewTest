//
//  ProfileViewController.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 03/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var profilePrice : String? = ""
    var profileFirst : String? = ""
    var profileSecond : String? = ""
    var profileThird : String? = ""
    var profileLocation : String? = ""
    var profileDesc : String? = ""
    var profileName : String? = ""
    var profileImage : String? = ""
    var profileRating : String? = ""
    var currentUserID = FIRAuth.auth()?.currentUser?.uid
    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser
    var saveIconCenter : CGPoint!
    var backButtonCenter : CGPoint!

    @IBOutlet weak var editButton: UIButton!{
        didSet {
            editButton.circlerImage()
        }
    }
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.circlerImage()
        }
    }
    @IBOutlet weak var priceTextField: UITextField!{
        didSet{
            priceTextField.borderColor()
        }
    }
    @IBOutlet weak var firstTextField: UITextField!{
        didSet{
            firstTextField.borderColor()
        }
    }
    @IBOutlet weak var secondTextField: UITextField!{
        didSet{
            secondTextField.borderColor()
        }
    }
    @IBOutlet weak var thirdTextField: UITextField!{
        didSet{
            thirdTextField.borderColor()
        }
    }
    @IBOutlet weak var locationTextView: UITextView!{
        didSet{
            locationTextView.layer.borderColor = UIColor.orange.cgColor
            locationTextView.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var descTextView: UITextView!{
        didSet{
            descTextView.layer.borderWidth = 1.0
            descTextView.layer.borderColor = UIColor.orange.cgColor
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!{
        didSet{
            backButton.circlerImage()
            backButton.borderColors()
        }
    }
    @IBOutlet weak var saveButton: UIButton!{
        didSet{
            saveButton.circlerImage()
            saveButton.borderColors()
        }
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButtonCenter = self.backButton.center
        self.saveIconCenter = self.saveButton.center
        listenToFirebase()
        setupProfile()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    func setupUI() {
        self.backButton.center = self.editButton.center
        self.saveButton.center = self.editButton.center
        priceTextField.isUserInteractionEnabled = false
        firstTextField.isUserInteractionEnabled = false
        secondTextField.isUserInteractionEnabled = false
        thirdTextField.isUserInteractionEnabled = false
        locationTextView.isUserInteractionEnabled = false
        descTextView.isUserInteractionEnabled = false
        imageView.isUserInteractionEnabled = false
    }
    
    func setupProfile() {
        
        nameLabel.text = profileName
        priceTextField.text = profilePrice
        firstTextField.text = profileFirst
        secondTextField.text = profileSecond
        thirdTextField.text = profileThird
        locationTextView.text = profileLocation
        descTextView.text = profileDesc
        if let profileURL = profileImage {
            imageView.loadImageUsingCacheWithUrlString(profileURL)
            imageView.circlerImage()
        }
        
    }
    
    func goToPage(page: String) {
        let gameScene = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: page) as UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = gameScene
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        goToPage(page: "ViewController")
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let updatedLocation = locationTextView.text,
        let updatedDesc = descTextView.text,
        let updatedPrice = priceTextField.text,
        let updatedFirst = firstTextField.text,
        let updatedSecond = secondTextField.text,
        let updatedThird = thirdTextField.text else {return}
        
        let values : [String : Any] = ["location": updatedLocation, "desc": updatedDesc, "subject": updatedFirst, "secondSubject": updatedSecond, "thirdSubject": updatedThird, "price": updatedPrice]
        FIRDatabase.database().reference().child("users").child(currentUserID!).updateChildValues(values)
        
    }
    
    func uploadImage(_ image: UIImage) {
        let userEmail = FIRAuth.auth()?.currentUser?.email
        let ref = FIRStorage.storage().reference().child("profile_images").child("\(userEmail).jpg")
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        ref.put(imageData, metadata: nil, completion: { (meta, error) in
         
            if let downloadPath = meta?.downloadURL()?.absoluteString {
                //save to firebase database
                self.saveImagePath(downloadPath)
                
                print("")
            }
            
        })
        
        
    }
    
    func saveImagePath(_ path: String) {
        
        let profilePictureValue : [String: Any] = ["profileImageUrl": path]
        
        FIRDatabase.database().reference().child("users").child(currentUserID!).updateChildValues(profilePictureValue)
    }

    
    func handleImage(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseProfileImage))
        imageView.addGestureRecognizer(tap)
        
    }
    
    func chooseProfileImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }

    
    func listenToFirebase() {
        FIRDatabase.database().reference().child("users").child(currentUserID!).observe(.value, with: { (snapshot) in
            
            let dictionary = snapshot.value as? [String : Any]
            
            self.profileName = dictionary?["name"] as? String
            self.profileLocation = dictionary?["location"] as? String
            self.profileDesc = dictionary?["desc"] as? String
            self.profilePrice = dictionary?["price"] as? String
            self.profileFirst = dictionary?["subject"] as? String
            self.profileSecond = dictionary?["secondSubject"] as? String
            self.profileThird = dictionary?["thirdSubject"] as? String
            self.profileImage = dictionary?["profileImageUrl"] as? String
            self.profileRating = dictionary?["rating"] as? String
            
            self.setupProfile()
        })
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    @IBAction func editButtonTapped(_ sender: UIButton) {
        if editButton.currentBackgroundImage == #imageLiteral(resourceName: "editButtonOff") {
            editButton.setBackgroundImage(#imageLiteral(resourceName: "editButton"), for: .normal)
            
            editLabel.text = "Editing..."
            priceTextField.isUserInteractionEnabled = true
            firstTextField.isUserInteractionEnabled = true
            secondTextField.isUserInteractionEnabled = true
            thirdTextField.isUserInteractionEnabled = true
            locationTextView.isUserInteractionEnabled = true
            descTextView.isUserInteractionEnabled = true
            imageView.isUserInteractionEnabled = true
            
            self.handleImage()
            
            UIView.animate(withDuration: 0.3, animations: {
                self.backButton.center = self.backButtonCenter
                self.saveButton.center = self.saveIconCenter
            })
           
            
            
            
            
        } else {
            editButton.setBackgroundImage(#imageLiteral(resourceName: "editButtonOff"), for: .normal)
            editLabel.text = "Done"
            
            UIView.animate(withDuration: 0.3, animations: {
                self.backButton.center = self.editButton.center
                self.saveButton.center = self.editButton.center
            })
           
            setupUI()
        }
        
    }

}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("User canceled out of picker")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker
        {
            imageView.image = selectedImage
            uploadImage(selectedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
