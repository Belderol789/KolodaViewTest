//
//  LoginViewController.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 02/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            logoImageView.circlerImage()
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserExist()
        setupUI()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
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
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = UIColor.orange.cgColor
        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = true
        signupButton.layer.borderWidth = 1.0
        signupButton.layer.borderColor = UIColor.orange.cgColor
        signupButton.layer.cornerRadius = 20
        signupButton.layer.masksToBounds = true
        facebookLoginButton.layer.borderWidth = 1.0
        facebookLoginButton.layer.borderColor = UIColor.orange.cgColor
        facebookLoginButton.layer.cornerRadius = 20
        facebookLoginButton.layer.masksToBounds = true
        
        
    }
 
    
    func goToPage(page: String) {
        
        let gameScene = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: page) as UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = gameScene
        
    }

    
    
    

 

}
