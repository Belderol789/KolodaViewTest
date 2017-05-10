//
//  ReviewListViewController.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 09/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase
import Cosmos

class ReviewListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var review : String? = ""
    var rating : String? = ""
    var currentUserID : String! = ""
    var usersReviews : [User] = []
    var reviewedUser : User?
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(ReviewTableViewCell.cellNib, forCellReuseIdentifier: ReviewTableViewCell.cellIdentifier)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchReviews()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchReviews() {
        FIRDatabase.database().reference().child("users").child(currentUserID).observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String : Any] {
            let userReview = dictionary["review"] as? String
            let userRating = dictionary["rating"] as? String
            self.reviewedUser?.rating = userRating
            self.reviewedUser?.review = userReview ?? "No review"
          
                
                self.usersReviews.append(self.reviewedUser!)

            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.cellIdentifier, for: indexPath) as! ReviewTableViewCell
        let currentReviewdUser = usersReviews[indexPath.row]
        cell.reviewTextView.text = currentReviewdUser.review
        cell.ratingView.rating = Double(currentReviewdUser.rating!)!
        
        
        return cell
        
    }
    


}
