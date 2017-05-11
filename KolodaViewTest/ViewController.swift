//
//  ViewController.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 02/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase



class ViewController: UIViewController, UISearchBarDelegate {

    var tutorUsers = [User]()
    var tuteeUsers = [User]()
    var users = [User]()
    var filteredUsers = [User]()
    var profileButtonCenter : CGPoint!
    var offeredButtonCenter : CGPoint!
    var logoutButtonCenter : CGPoint!
    var currentUserId : String? = ""
    var currentUserStatus : String? = ""
    var userRole : String! = ""
    var myRole : String! = ""
    var images = [UIImage]()
    var roles = [String]()
    
    
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
            menuButton.layer.borderWidth = 1
            menuButton.layer.borderColor = UIColor.black.cgColor
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
        

        currentUserId = FIRAuth.auth()?.currentUser?.uid
       // fetchUser()
        fetchUserRole()
        setupSearchBar()
        setupButtonCenters()
        setupAnimation()

    }

       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func  setupSearchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 70))
        searchBar.delegate = self
        self.userTableView.tableHeaderView = searchBar
        self.userTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
            self.userTableView.reloadData()
        }else {
            filterTableView(text: searchText)
        }
    }
    
    func filterTableView(text:String) {
        filteredUsers = users.filter({ (user) -> Bool in
            return (user.name?.lowercased().contains(text.lowercased()))! || (user.firstSub?.lowercased().contains(text.lowercased()))! || (user.location?.lowercased().contains(text.lowercased()))!
        })
        self.userTableView.reloadData()
        
    }

    
    @IBAction func offerButtonTapped(_ sender: Any) {
        
        goToPage(page: "OfferedViewController")
        
    }
    
    func setupButtonCenters() {
        profileButtonCenter = profileButton.center
        offeredButtonCenter = offeredButton.center
        logoutButtonCenter = logoutButton.center
    }
    
    func setupAnimation() {
        profileButton.center = menuButton.center
        offeredButton.center = menuButton.center
        logoutButton.center = menuButton.center

    }
    
    @IBAction func menuButtonClicked(_ sender: UIButton) {
        if menuButton.currentBackgroundImage == #imageLiteral(resourceName: "moreButton") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "moreButtonOff"), for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                
                self.profileButton.alpha = 1
                self.offeredButton.alpha = 1
                self.logoutButton.alpha = 1
                
                self.profileButton.isUserInteractionEnabled = true
                self.offeredButton.isUserInteractionEnabled = true
                self.logoutButton.isUserInteractionEnabled = true
                
                self.profileButton.center = self.profileButtonCenter
                self.offeredButton.center = self.offeredButtonCenter
                self.logoutButton.center = self.logoutButtonCenter
            })
        } else {
            menuButton.setBackgroundImage(#imageLiteral(resourceName: "moreButton"), for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                
                self.profileButton.alpha = 0
                self.offeredButton.alpha = 0
                self.logoutButton.alpha = 0
                
                self.profileButton.isUserInteractionEnabled = false
                self.offeredButton.isUserInteractionEnabled = false
                self.logoutButton.isUserInteractionEnabled = false

                self.profileButton.center = self.menuButton.center
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
    
    
    func fetchUserRole() {
        FIRDatabase.database().reference().child("users").child(currentUserId!).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                self.myRole = dictionary["role"] as? String
                
                self.fetchUser()
            }
        })
    }

    
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : Any] {
                let user = User(dictionary: dictionary)
                self.userRole = dictionary["role"] as? String
                user.uid = snapshot.key
                
                if self.myRole == "tutor" {
                    if self.userRole == "tutee" {
                        self.tuteeUsers.append(user)
                        self.users = self.tuteeUsers
                    }
                } else if self.myRole == "tutee" {
                    if self.userRole == "tutor" {
                        self.tutorUsers.append(user)
                        self.users = self.tutorUsers
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.filteredUsers = self.users
                self.userTableView.reloadData()
                
            }
        })
        
    }
    
}



extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellIdentifier, for: indexPath) as? UserTableViewCell else {return UITableViewCell()}
        let user = filteredUsers[indexPath.row]
        if let profileImageUrl = user.profileImageUrl {
            print("userImage: ",user.profileImageUrl ?? "")
            cell.profileImage.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        cell.nameLabel.text = user.name
        cell.locationLabel.text = user.location
        cell.priceRangeLabel.text = user.price
        cell.subjectLabel.text = user.firstSub
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


