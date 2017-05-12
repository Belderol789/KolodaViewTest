//
//  ProfileViewController.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 03/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase
import Social
import Cosmos

class ProfileViewController: UIViewController {
    

    var profileImage : String? = ""
    var profileRating : String? = ""
    var currentUserID = FIRAuth.auth()?.currentUser?.uid
    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser

    @IBOutlet weak var viewCosmos: CosmosView!
    @IBOutlet weak var credentialView: UIView!{
        didSet{
            credentialView.layer.borderWidth = 1
            credentialView.layer.borderColor = UIColor.orange.cgColor
        }
    }
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.circlerImage()
        }
    }
    @IBOutlet weak var priceTextField: UITextField!{
        didSet{
            priceTextField.layer.borderWidth = 1
            priceTextField.layer.borderColor = UIColor.orange.cgColor
        }
    }
    @IBOutlet weak var firstTextField: UITextField!{
        didSet{
            firstTextField.layer.borderWidth = 1
            firstTextField.layer.borderColor = UIColor.orange.cgColor
        }
    }
    @IBOutlet weak var secondTextField: UITextField!{
        didSet{
            secondTextField.layer.borderWidth = 1
            secondTextField.layer.borderColor = UIColor.orange.cgColor
        }
    }
    @IBOutlet weak var roleLabel: UILabel!
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
   
    @IBOutlet weak var thirdTextField: UITextField!{
        didSet{
            thirdTextField.layer.borderWidth = 1
            thirdTextField.layer.borderColor = UIColor.orange.cgColor
        }
    }
    @IBOutlet weak var locationTextView: UITextView!{
        didSet{
            locationTextView.text = "Where would you like to meetup?"
            locationTextView.layer.borderWidth = 1
            locationTextView.layer.borderColor = UIColor.orange.cgColor
        }
    }
    @IBOutlet weak var descTextView: UITextView!{
        didSet{
            descTextView.text = "Say something about yourself!"
            descTextView.layer.borderWidth = 1
            descTextView.layer.borderColor = UIColor.orange.cgColor
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
    @IBOutlet weak var shareButton: UIButton!{
        didSet{
            shareButton.circlerImage()
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        checkTextViews()
        listenToFirebase()
        setupProfile()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    func setupUI() {
        self.tuteeButton.alpha = 0
        self.tutorButton.alpha = 0
        priceTextField.isUserInteractionEnabled = false
        firstTextField.isUserInteractionEnabled = false
        secondTextField.isUserInteractionEnabled = false
        thirdTextField.isUserInteractionEnabled = false
        locationTextView.isUserInteractionEnabled = false
        descTextView.isUserInteractionEnabled = false
        imageView.isUserInteractionEnabled = false
        viewCosmos.isUserInteractionEnabled = false
    }
    
    func setupProfile() {
        
        if let profileURL = profileImage {
            imageView.loadImageUsingCacheWithUrlString(profileURL)
            imageView.circlerImage()
        }
        
    }
    
    func goToPage(page: String) {
        let gameScene = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: page) as UIViewController
        present(gameScene, animated: true, completion: nil)

        
    }

    @IBAction func shareButtonTapped(_ sender: Any) {
       let shareAlert = UIAlertController(title: "Share on Social Media", message: "Reach out to more users", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let fbShare = UIAlertAction(title: "Share on Facebook", style: .default) { (action) in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                post?.setInitialText("Check out my Profile!")
                post?.add(UIImage(named: self.profileImage!))
                
                self.present(post!, animated: true, completion: nil)
                
            } else {
                self.showAlert(service: "Facebook")
            }
 
        }
        shareAlert.addAction(fbShare)
        shareAlert.addAction(cancel)
        self.present(shareAlert, animated: true, completion: nil)
      
    }
    
    func showAlert(service: String) {
        let alert = UIAlertController(title: "Error", message: "You are not connected to \(service)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        //goToPage(page: "ViewController")
    }
    
    
    @IBAction func changeRoleTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.tutorButton.alpha = 1
            self.tuteeButton.alpha = 1

        })
    }

    @IBAction func tutorButtonTapped(_ sender: Any) {
        tuteeButton.isUserInteractionEnabled = false
        FIRDatabase.database().reference().child("users").child(currentUserID!).updateChildValues(["role" : "tutor"])
 
    }
    @IBAction func tuteeButtonTapped(_ sender: Any) {

        tutorButton.isUserInteractionEnabled = false
        FIRDatabase.database().reference().child("users").child(currentUserID!).updateChildValues(["role" : "tutee"])
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
    
    @IBAction func editButtonTapped(_ sender: Any) {
        priceTextField.isUserInteractionEnabled = true
        firstTextField.isUserInteractionEnabled = true
        secondTextField.isUserInteractionEnabled = true
        thirdTextField.isUserInteractionEnabled = true
        locationTextView.isUserInteractionEnabled = true
        descTextView.isUserInteractionEnabled = true
        imageView.isUserInteractionEnabled = true
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        priceTextField.isUserInteractionEnabled = false
        firstTextField.isUserInteractionEnabled = false
        secondTextField.isUserInteractionEnabled = false
        thirdTextField.isUserInteractionEnabled = false
        locationTextView.isUserInteractionEnabled = false
        descTextView.isUserInteractionEnabled = false
        imageView.isUserInteractionEnabled = false
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
            
            self.nameLabel.text = dictionary?["name"] as? String
            self.locationTextView.text = dictionary?["location"] as? String
            self.descTextView.text = dictionary?["desc"] as? String
            self.priceTextField.text = dictionary?["price"] as? String
            self.firstTextField.text = dictionary?["subject"] as? String
            self.secondTextField.text = dictionary?["secondSubject"] as? String
            self.thirdTextField.text = dictionary?["thirdSubject"] as? String
            self.profileImage = dictionary?["profileImageUrl"] as? String
            self.profileRating = dictionary?["rating"] as? String
            self.roleLabel.text = dictionary?["role"] as? String
            
            self.setupProfile()
        })
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
