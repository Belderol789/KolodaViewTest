//
//  SignupViewController.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 02/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.circlerImage()
            imageView.borderColors()
            
        }
    }
    @IBOutlet weak var firstSubTextField: UITextField!{
        didSet {
            firstSubTextField.borderColor()
        }
    }
    @IBOutlet weak var secondSubTextField: UITextField!{
        didSet{
            secondSubTextField.borderColor()
        }
    }
    @IBOutlet weak var thirdSubTextField: UITextField!{
        didSet{
            thirdSubTextField.borderColor()
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var detailView: UIView! {
        didSet {
            detailView.layer.borderWidth = 1.0
            detailView.layer.borderColor = UIColor.orange.cgColor
        }
    }
    @IBOutlet weak var credentialView: UIView! {
        didSet {
            credentialView.layer.borderWidth = 1.0
            credentialView.layer.borderColor = UIColor.orange.cgColor
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
  
       
        handleImage()
        setupUI()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }

    @IBAction func signupButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text, let gender = genderTextField.text, let age = ageTextField.text, let name = nameTextField.text, let location = locationTextField.text, let subject = firstSubTextField.text, let secondSubject = secondSubTextField.text, let thirdSubject = thirdSubTextField.text else {return}
        
        if email == "" || password  == "" || gender  == "" || age  == "" || name  == "" || location == "" || subject == "" {
            
            addAlertAndAction(title: "Required Field Missing", message: "Kindly fill-in the required fields", actionTitle: "Ok")
            
            if confirmPassword != password {
                addAlertAndAction(title: "Password Mismatched", message: "Kindly retype your password", actionTitle: "Ok")
                
            }

            return
         
            
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                self.addAlertAndAction(title: "Error", message: (error?.localizedDescription)!, actionTitle: "Ok")
                return
            }
            
            
            
            guard let uid = user?.uid else {
                return
            }
            
            let imageName = email
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
            if let profileImage = self.imageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl, "uid" : uid, "age" : age, "gender" : gender, "location" : location, "price" : "50Php/hr", "subject": subject, "desc" : self.textView.text, "secondSubject" : secondSubject, "thirdSubject" : thirdSubject] as [String : Any]
                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                        self.goToPage(page: "ViewController")
                    }
                })
            }

        })
    }
    
    private func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }

        })
    }

    
    func setupUI() {
        signupButton.layer.borderWidth = 1.0
        signupButton.layer.borderColor = UIColor.orange.cgColor
        signupButton.layer.cornerRadius = 20
        signupButton.layer.masksToBounds = true
    }
    
  
    
    func handleImage() {
        
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseProfileImage))
        imageView.addGestureRecognizer(tap)
        
    }
    
    func chooseProfileImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func addAlertAndAction(title: String, message: String, actionTitle: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.destructive, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func goToPage(page: String)
    {
        let controller = storyboard?.instantiateViewController(withIdentifier: page)
        present(controller!, animated: true, completion: nil)
        
    }

}
extension SignupViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

