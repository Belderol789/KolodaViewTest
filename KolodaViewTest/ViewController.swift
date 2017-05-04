//
//  ViewController.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 02/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    
    var users = [User]()
    var profileButtonCenter : CGPoint!
    var offeredButtonCenter : CGPoint!
    var savedButtonCenter : CGPoint!
    var logoutButtonCenter : CGPoint!
    
    @IBOutlet weak var userTableView: UITableView! {
        didSet{
             userTableView.register(UserTableViewCell.cellNib, forCellReuseIdentifier: UserTableViewCell.cellIdentifier)
            userTableView.delegate = self
            userTableView.dataSource = self
        }
    }
    @IBOutlet weak var menuButton: UIButton! {
        didSet {
            menuButton.circlerImage()
        }
    }
    @IBOutlet weak var profileButton: UIButton!{
        didSet {
            profileButton.circlerImage()
        }
    }
    @IBOutlet weak var offeredButton: UIButton!{
        didSet {
            offeredButton.circlerImage()
        }
    }
    @IBOutlet weak var savedButton: UIButton!{
        didSet {
            savedButton.circlerImage()
            savedButton.layer.borderWidth = 2.0
            savedButton.layer.borderColor = UIColor.black.cgColor
        }
    }

    @IBOutlet weak var logoutButton: UIButton! {
        didSet {
            logoutButton.circlerImage()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        profileButtonCenter = profileButton.center
        savedButtonCenter = savedButton.center
        offeredButtonCenter = offeredButton.center
        logoutButtonCenter = logoutButton.center
        
        setupAnimation()
 
        
    }

       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func setupAnimation() {
        profileButton.center = menuButton.center
        savedButton.center = menuButton.center
        offeredButton.center = menuButton.center
        logoutButton.center = menuButton.center

    }
    
    @IBAction func menuButtonClicked(_ sender: UIButton) {
        if menuButton.currentBackgroundImage == #imageLiteral(resourceName: "moreButton") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "moreButtonOff"), for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                
                self.profileButton.alpha = 1
                self.offeredButton.alpha = 1
                self.savedButton.alpha = 1
                self.logoutButton.alpha = 1
                
                self.profileButton.isUserInteractionEnabled = true
                self.offeredButton.isUserInteractionEnabled = true
                self.savedButton.isUserInteractionEnabled = true
                self.logoutButton.isUserInteractionEnabled = true
                
                self.profileButton.center = self.profileButtonCenter
                self.offeredButton.center = self.offeredButtonCenter
                self.savedButton.center = self.savedButtonCenter
                self.logoutButton.center = self.logoutButtonCenter
            })
        } else {
            menuButton.setBackgroundImage(#imageLiteral(resourceName: "moreButton"), for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                
                self.profileButton.alpha = 0
                self.offeredButton.alpha = 0
                self.savedButton.alpha = 0
                self.logoutButton.alpha = 0
                
                self.profileButton.isUserInteractionEnabled = false
                self.offeredButton.isUserInteractionEnabled = false
                self.savedButton.isUserInteractionEnabled = false
                self.logoutButton.isUserInteractionEnabled = false

                self.profileButton.center = self.menuButton.center
                self.savedButton.center = self.menuButton.center
                self.offeredButton.center = self.menuButton.center
                self.logoutButton.center = self.menuButton.center
            })
        }

    }
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        do {
            try FIRAuth.auth()?.signOut()
            
            guard let loginController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController")else{return}
            ad.window?.rootViewController = loginController
            
            
            
        } catch let logoutError {
            print(logoutError)
        }

    }
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        goToPage(page: "ProfileViewController")
    }
    
    func goToPage(page: String)
    {
        
        let gameScene = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: page) as UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = gameScene
        
    }

    
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : Any] {
                let user = User(dictionary: dictionary)
                user.uid = snapshot.key
                if(user.uid == FIRAuth.auth()?.currentUser?.uid) {
                    
                } else {
                    self.users.append(user)
                }
                
                DispatchQueue.main.async(execute: { 
                    self.userTableView.reloadData()
                })
                
            }
            
        })
    }
    
}

extension ViewController : UITableViewDelegate {
    
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellIdentifier, for: indexPath) as? UserTableViewCell else {return UITableViewCell()}
        let user = users[indexPath.row]
        if let profileImageUrl = user.profileImageUrl {
            print("userImage: ",user.profileImageUrl ?? "")
            cell.profileImage.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        cell.nameLabel.text = user.name
        cell.locationLabel.text = user.location
        cell.priceRangeLabel.text = user.price
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        guard let userController = storyboard?.instantiateViewController(withIdentifier: "UserViewController") as? UserViewController else {return}
        
        userController.selectedProfile = selectedUser
        userController.otherUserID = selectedUser.uid!
        present(userController, animated: true, completion: nil)
    }
}


