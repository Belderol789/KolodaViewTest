//
//  OfferedViewController.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 05/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase

class OfferedViewController: UIViewController {
    
    @IBOutlet weak var offerSegmentedControl: UISegmentedControl!
    var offeredToID : String? = ""
    var offerLocation : String? = ""
    var offeresImage : String? = ""
    var offerPrice : String? = ""
    var offerSchedule : String? = ""
    var offerSubject : String? = ""
    var offerName : String? = ""
    var currentUserName : String? = ""
    var users : [User] = []
    var secondUsers : [User] = []

    var ref : FIRDatabaseReference!

    @IBOutlet weak var firstTableView: UITableView!{
        didSet{
            firstTableView.register(OfferedTableViewCell.cellNib, forCellReuseIdentifier: OfferedTableViewCell.cellIdentifier)
            firstTableView.delegate = self
            firstTableView.dataSource = self
            
        }
    }
//    @IBOutlet weak var secondTableView: UITableView!{
//        didSet{
//            secondTableView.register(OfferedTableViewCell.cellNib, forCellReuseIdentifier: OfferedTableViewCell.cellIdentifier)
//            secondTableView.delegate = self
//            secondTableView.delegate = self
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchOfferedUser()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        firstTableView.reloadData()
    
    }
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        firstTableView.reloadData()
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        //dismiss(animated: true, completion: nil)
        present(viewController, animated: true, completion: nil)
        
    }
    
    func fetchOfferedUser() {
        self.ref = FIRDatabase.database().reference()
        ref.child("offers").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : Any] {
                //let user = User(dictionary: dictionary)
                let currentUserID = dictionary["offeredBy"] as! String
                self.offerLocation = dictionary["location"] as? String
                self.offerSchedule = dictionary["schedule"] as? String
                self.offerPrice = dictionary["price"] as? String
                self.offeresImage = dictionary["offeresImage"] as? String
                self.offerSubject = dictionary["subject"] as? String
                self.offerName = dictionary["name"] as? String
                self.currentUserName = dictionary["myName"] as? String
                self.offeredToID = dictionary["offeredTo"] as? String
                
              
                    
                    let newUser = User()
                    newUser.location = self.offerLocation
                    newUser.schedule = self.offerSchedule
                    newUser.price = self.offerPrice
                    newUser.firstSub = self.offerSubject
                    newUser.profileImageUrl = self.offeresImage
                    newUser.name = self.offerName
                    newUser.offeredBy = self.currentUserName
                    
                  if FIRAuth.auth()?.currentUser?.uid == currentUserID {
                    
                     self.users.append(newUser)
                  
                    
                } else if FIRAuth.auth()?.currentUser?.uid == self.offeredToID {
                    
//                    let newUser = User()
//                    newUser.location = self.offerLocation
//                    newUser.schedule = self.offerSchedule
//                    newUser.price = self.offerPrice
//                    newUser.firstSub = self.offerSubject
//                    newUser.profileImageUrl = self.offeresImage
//                    newUser.name = self.offerName
//                    newUser.offeredBy = self.currentUserName
//                    
                    self.secondUsers.append(newUser)
                    
                }

                DispatchQueue.main.async(execute: {
                    self.firstTableView.reloadData()
                    
                })
                

            }

        })
   
    }

}

extension OfferedViewController : UITableViewDelegate {
    
}

extension OfferedViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfUsers = 0
        switch (offerSegmentedControl.selectedSegmentIndex) {
        case 0:
            numberOfUsers = users.count
        case 1:
            numberOfUsers = secondUsers.count
        default:
            break
        }
        
        return numberOfUsers

//        if (tableNumber == 1) {
//            numberOfUsers = users.count
//            return numberOfUsers
//            
//        } else if (tableNumber == 2) {
//            numberOfSecondUsers = secondUsers.count
//            return numberOfSecondUsers
//        } else {
//            return 0
//        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: OfferedTableViewCell.cellIdentifier, for: indexPath) as? OfferedTableViewCell else {return UITableViewCell()}
        
        
        switch (offerSegmentedControl.selectedSegmentIndex) {
        case 0:
            let currentUser = users[indexPath.row]
            cell.nameLabel.text = currentUser.name
            cell.locationTextView.text = currentUser.location
            cell.priceLabel.text = currentUser.price! + "/hr"
            cell.subjectLabel.text = currentUser.firstSub
            cell.scheduleLabel.text = currentUser.schedule
            if let profileImageUrl = currentUser.profileImageUrl {
                print("userImage: ",currentUser.profileImageUrl ?? "")
                cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            }
            break
        case 1:
            let currentSecondUser = secondUsers[indexPath.row]
            cell.nameLabel.text = currentSecondUser.offeredBy
            cell.locationTextView.text = currentSecondUser.location
            cell.priceLabel.text = currentSecondUser.price! + "/hr"
            cell.subjectLabel.text = currentSecondUser.firstSub
            cell.scheduleLabel.text = currentSecondUser.schedule
            if let profileImageUrl = currentSecondUser.profileImageUrl {
                print("userImage: ",currentSecondUser.profileImageUrl ?? "")
                cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            }
            break
        default:
            break
        }
        

//        if (tableNumber == 1) {
//         
//            let currentUser = users[indexPath.row]
//            cell.nameLabel.text = currentUser.name
//            cell.locationTextView.text = currentUser.location
//            cell.priceLabel.text = currentUser.price! + "/hr"
//            cell.subjectLabel.text = currentUser.firstSub
//            cell.scheduleLabel.text = currentUser.schedule
//            if let profileImageUrl = currentUser.profileImageUrl {
//                print("userImage: ",currentUser.profileImageUrl ?? "")
//                cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
//            }
//
//        } else if (tableNumber == 2) {
//       
//            let currentSecondUser = secondUsers[indexPath.row]
//            cell.nameLabel.text = currentSecondUser.offeredBy
//            cell.locationTextView.text = currentSecondUser.location
//            cell.priceLabel.text = currentSecondUser.price! + "/hr"
//            cell.subjectLabel.text = currentSecondUser.firstSub
//            cell.scheduleLabel.text = currentSecondUser.schedule
//            if let profileImageUrl = currentSecondUser.profileImageUrl {
//                print("userImage: ",currentSecondUser.profileImageUrl ?? "")
//                cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
//            }
//
//        }
      
        return cell
    }

}
