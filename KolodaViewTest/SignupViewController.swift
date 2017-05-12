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
    
    
    var role : String? = "tutee"
    var id : String = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstSubTextField: UITextField!
    @IBOutlet weak var secondSubTextField: UITextField!
    @IBOutlet weak var thirdSubTextField: UITextField!
    @IBOutlet weak var choiceView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.layer.borderColor = UIColor.lightGray.cgColor
            textView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var tutorButton: UIButton!
    @IBOutlet weak var tuteeButton: UIButton!
    @IBOutlet weak var detailView: UIView!{
        didSet{
            detailView.layer.cornerRadius = 10
            detailView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var credentialView: UIView!{
        didSet{
            credentialView.layer.cornerRadius = 10
            credentialView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var viewWithImage: UIView!{
        didSet{
            viewWithImage.layer.cornerRadius = 10
            viewWithImage.layer.masksToBounds = true
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        choiceView.alpha = 0
        handleImage()
        setupUI()

        
    }

 
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        
        dismiss(animated: true, completion: nil)
         //goToPage(page: "LoginViewController")
        
    }
  
    
    @IBAction func signupButtonTapped(_ sender: Any) {
      
        if emailTextField.text == "" || passwordTextField.text  == "" || genderTextField.text == "" || ageTextField.text  == "" || nameTextField.text  == "" || locationTextField.text == "" || firstSubTextField.text == "" {
            
            addAlertAndAction(title: "Required Field Missing", message: "Kindly fill-in the required fields", actionTitle: "Ok")
            
            if confirmPasswordTextField.text != passwordTextField.text {
                addAlertAndAction(title: "Password Mismatched", message: "Kindly retype your password", actionTitle: "Ok")
                
            }

            return

        }

        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                self.addAlertAndAction(title: "Error", message: (error?.localizedDescription)!, actionTitle: "Ok")
                return
            }
            
            let imageName = self.emailTextField.text
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
            if let profileImage = self.imageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": self.nameTextField.text!, "email": self.emailTextField.text!, "profileImageUrl": profileImageUrl, "uid" : (user?.uid)!, "age" : self.ageTextField.text!, "gender" : self.genderTextField.text!, "location" : self.locationTextField.text!, "price" : "50", "subject": self.firstSubTextField.text!, "desc" : self.textView.text, "secondSubject" : self.secondSubTextField.text ?? "None", "thirdSubject" : self.thirdSubTextField.text ?? "None", "rating" : "0", "role" : self.role ?? "none", "review" : "No review"] as [String : Any]
                        self.registerUserIntoDatabaseWithUID((user?.uid)!, values: values as [String : AnyObject])
                        self.id = (user?.uid)!
                        self.chooseRoleView()
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
    
        signupButton.layer.cornerRadius = 20
        signupButton.layer.masksToBounds = true
   
        cancelButton.layer.cornerRadius = 20
        cancelButton.layer.masksToBounds = true
        
        
        imageView.circlerImage()
        imageView.layer.borderColor = UIColor.orange.cgColor
        imageView.layer.borderWidth = 1.0
        
        
        tuteeButton.circlerImage()
        tutorButton.circlerImage()
        
        textView.text = "Say something about yourself such as work experience or your educational background."
    
        
        
        
    }
    @IBAction func removeText(_ sender: Any) {
        textView.text = ""
    }

    func handleImage() {
        
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseProfileImage))
        imageView.addGestureRecognizer(tap)
        
    }
    
    func chooseRoleView() {
        
        UIView.animate(withDuration: 0.3, animations: {
          
            self.choiceView.alpha = 0.95
            self.tutorButton.addTarget(self, action: #selector(self.tutorButtonTapped(_:)), for: .touchUpInside)
            self.tuteeButton.addTarget(self, action: #selector(self.tuteeButtonTapped(_:)), for: .touchUpInside)
            
        })
    }
    
    func tutorButtonTapped(_ sender: Any) {
        tuteeButton.isUserInteractionEnabled = false
        FIRDatabase.database().reference().child("users").child(id).updateChildValues(["role" : "tutor"])
      
        goToPage(page: "ViewController")
    }
    
     func tuteeButtonTapped(_ sender: Any) {
        tutorButton.isUserInteractionEnabled = false
        FIRDatabase.database().reference().child("users").child(id).updateChildValues(["role" : "tutee"])
        
        goToPage(page: "ViewController")
        
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
        let gameScene = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: page) as UIViewController
        dismiss(animated: true, completion: nil)
        present(gameScene, animated: true, completion: nil)
        
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

