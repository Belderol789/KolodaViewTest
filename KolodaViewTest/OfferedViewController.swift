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
    var offerIds : [String] = []
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
                 let currentUserID = dictionary["offeredBy"] as! String
                if FIRAuth.auth()?.currentUser?.uid == currentUserID {
                    print(123)
                }
                

            }

        })
        
            
            
            
//            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                for child in result {
//                    let userKey = child.key 
//                    self.ref.child("offers").child(userKey).observe(.childAdded, with: { (snapshot) in
//                        
//                        if let dictionary = snapshot.value as? [String : Any] {
//                            let userId = dictionary["offeredBy"] as? String
//                            print(userId)
//                            
//                        }
//                    })
//                    
//                }
//            }
    }
    
    
  
}

extension OfferedViewController : UITableViewDelegate {
    
}

extension OfferedViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OfferedTableViewCell.cellIdentifier, for: indexPath) as? OfferedTableViewCell else {return UITableViewCell()}
        
        return cell
    }
    
    
    
    
}
