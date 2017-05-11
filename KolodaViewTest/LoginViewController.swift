//
//  LoginViewController.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 02/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    var FBUserName : String! = ""
    var FBUserID : String! = ""
    var FBGender : String? = ""
    var FBEmail : String! = ""
    var FBUserPhoto : String! = ""

    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            logoImageView.circlerImage()
        }
    }
    @IBOutlet weak var loginView: UIView!{
        didSet{
            loginView.layer.cornerRadius = 10
            loginView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!{
        didSet{
            signupButton.borderColors()
        }
    }
    @IBOutlet weak var facebookButton: FBSDKLoginButton! {
        didSet{
            facebookButton.delegate = self
            facebookButton.readPermissions = ["email", "public_profile"]
        }
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserExist()
        
        facebookLogin()
        setupUI()

        
    }

    func facebookLogin() {
        
        if (FBSDKAccessToken.current() == nil) {
            print(123)
        } else {
            print("Logged in to Facebook")
            
        }
    }

    
    func checkIfUserExist() {
        if(FIRAuth.auth()?.currentUser) != nil {
            goToPage(page: "ViewController")
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error signing in", message: (error?.localizedDescription)!, preferredStyle: UIAlertControllerStyle.alert)
                    let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: nil)
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    self.goToPage(page: "ViewController")
                    
                }
            })
        }

        
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        goToPage(page: "SignupViewController")
    }
    func setupUI() {
        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = true
        signupButton.layer.cornerRadius = 20
        signupButton.layer.masksToBounds = true
        
    }
 
    
    func goToPage(page: String) {
        
        let gameScene = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: page) as UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = gameScene
        
    }

}


extension LoginViewController : FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error)
            return
        }
        
        showEmailAddress()
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else {return}
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Something wrong with error user ", error!)
                return
            }
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email, birthday, age_range, location, gender, work"]).start { (completion, result, err) in
                if err != nil {
                    print("Failed to graph request", err!)
                    return
                }

                if let dictionary = result as? [String : Any] {
                    self.FBUserName = user!.displayName
                    self.FBUserPhoto = "\((user!.photoURL)!)"
                    self.FBUserID = dictionary["id"] as? String
                    self.FBGender = dictionary["gender"] as? String
                    self.FBEmail = dictionary["email"] as? String
                    guard let FBvalues : [String : Any] = ["name" : self.FBUserName, "gender" : self.FBGender!, "profileImageUrl" : self.FBUserPhoto, "role" : "tutee"] else {return}
                    
                    FIRDatabase.database().reference().child("users").child(self.FBUserID).updateChildValues(FBvalues)
                    

                }
                
                self.goToPage(page: "ViewController")
            }
            
           
            
            
            print("Successfully logged in ", user!)
        })
        
       
        
    }

}

