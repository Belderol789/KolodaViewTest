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
    var roleButtonCenter : CGPoint!

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
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    @IBOutlet weak var roleView: UIView!
    @IBOutlet weak var tuteeButton: UIButton!{
        didSet{
            tuteeButton.circlerImage()
        }
    }
    @IBOutlet weak var tutorButton: UIButton!{
        didSet{
            tutorButton.circlerImage()
        }
    }
    @IBOutlet weak var cancelButton: UIButton!{
        didSet{
            cancelButton.circlerImage()
        }
    }
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var locationTextView: UITextView!{
        didSet{
            locationTextView.text = "Where would you like to meetup?"
        }
    }
    @IBOutlet weak var descTextView: UITextView!{
        didSet{
            descTextView.text = "Say something about yourself!"
        }
    }
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var saveButton: UIButton!{
        didSet{
            saveButton.circlerImage()
    
        }
    }
    @IBOutlet weak var changeRoleButton: UIButton!{
        didSet{
            changeRoleButton.circlerImage()
        }
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkTextViews()
        self.roleButtonCenter = self.changeRoleButton.center
        self.saveIconCenter = self.saveButton.center
        listenToFirebase()
        setupProfile()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    func setupUI() {
        self.changeRoleButton.center = self.editButton.center
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

    
    @IBAction func backButtonTapped(_ sender: Any) {
          goToPage(page: "ViewController")
    }
    
    
    @IBAction func changeRoleTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.roleView.alpha = 0.95
        })
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
       dismissView()

    }
    @IBAction func tutorButtonTapped(_ sender: Any) {
        tuteeButton.isUserInteractionEnabled = false
        FIRDatabase.database().reference().child("users").child(currentUserID!).updateChildValues(["role" : "tutor"])
        dismissView()

    }
    @IBAction func tuteeButtonTapped(_ sender: Any) {
        tutorButton.isUserInteractionEnabled = false
        FIRDatabase.database().reference().child("users").child(currentUserID!).updateChildValues(["role" : "tutee"])
        dismissView()
    }
    
    func dismissView() {
        if let viewWithTag = self.view.viewWithTag(99) {
            print("Tag 99")
            viewWithTag.removeFromSuperview()
        }
        else {
            print("tag not found")
        }
    }
    
    @IBAction func locationPlaceHolder(_ sender: Any) {
        if locationTextView.text == "Where would you like to meetup?" {
            locationTextView.text = ""
            locationTextView.textColor = .black
        }
        
    }
    @IBAction func descPlaceHolder(_ sender: Any) {
        if locationTextView.text == "Say something about yourself!" {
            locationTextView.text = ""
            locationTextView.textColor = .black
        }
    }
    
    func checkTextViews() {
        if locationTextView.text == "" {
            locationTextView.text = "Where would you like to meetup?"
            locationTextView.textColor = .lightGray
        }
        
        if descTextView.text == "" {
            descTextView.text = "Say something about yourself!"
            descTextView.textColor = .lightGray
        }
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
                self.changeRoleButton.center = self.roleButtonCenter
                self.saveButton.center = self.saveIconCenter
            })
           
            
            
            
            
        } else {
            editButton.setBackgroundImage(#imageLiteral(resourceName: "editButtonOff"), for: .normal)
            editLabel.text = "Done"
            
            UIView.animate(withDuration: 0.3, animations: {
                self.changeRoleButton.center = self.editButton.center
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
