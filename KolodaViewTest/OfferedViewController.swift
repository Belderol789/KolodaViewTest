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
    
    var offeredToID : String = ""
    var offerLocation : String? = ""
    var offeresImage : String? = ""
    var offerPrice : String? = ""
    var offerSchedule : String? = ""
    var offerSubject : String? = ""
    var offerName : String? = ""
    var users : [User] = []

    var ref : FIRDatabaseReference!

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(OfferedTableViewCell.cellNib, forCellReuseIdentifier: OfferedTableViewCell.cellIdentifier)
            tableView.delegate = self
            tableView.dataSource = self
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchOfferedUser()
     
        

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
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
                
                if FIRAuth.auth()?.currentUser?.uid == currentUserID {
                    
                    let newUser = User()
                    newUser.location = self.offerLocation
                    newUser.schedule = self.offerSchedule
                    newUser.price = self.offerPrice
                    newUser.firstSub = self.offerSubject
                    newUser.profileImageUrl = self.offeresImage
                    newUser.name = self.offerName
                    
                    
                    self.users.append(newUser)
                    
                    
                }
                
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    
                })
                

            }

        })
        
            
    }
    
    
  
}

extension OfferedViewController : UITableViewDelegate {
    
}

extension OfferedViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OfferedTableViewCell.cellIdentifier, for: indexPath) as? OfferedTableViewCell else {return UITableViewCell()}
        
        let currentUser = users[indexPath.row]
        
        cell.nameLabel.text = currentUser.name
        cell.locationTextView.text = currentUser.location
        cell.priceLabel.text = currentUser.price
        cell.subjectLabel.text = currentUser.firstSub
        cell.scheduleLabel.text = currentUser.schedule

        
        return cell
    }
    
    
    
    
}
