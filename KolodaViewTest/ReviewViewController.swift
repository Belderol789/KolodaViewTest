//
//  ReviewViewController.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 08/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase
import Cosmos


class ReviewViewController: UIViewController {
    
    var selectedProfile : User?
    var currentUserID : String? = ""
    var review : String? = ""
    var selectedID : String! = ""

    @IBOutlet weak var cosmosRating: CosmosView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!{
        didSet{
            reviewTextView.layer.borderWidth = 1
            reviewTextView.layer.borderColor = UIColor.orange.cgColor
        }
    }
    @IBOutlet weak var submitButton: UIButton!{
        didSet{
            submitButton.curveEdges()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
      

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        
        let id = selectedID
        review = reviewTextView.text
        let cosmoRating = String(cosmosRating.rating)
        let userReview : [String : Any] = ["review" : review ?? "No review", "rating" : cosmoRating]
        
        FIRDatabase.database().reference().child("users").child((id)!).updateChildValues(userReview)
        
        let alert = UIAlertController(title: "Review Submitted", message: "Your review has been successfully submitted", preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)

    }
    
    func setupData() {
        
        if FIRAuth.auth()?.currentUser?.uid == selectedProfile?.uid {
            nameLabel.text = selectedProfile?.offeredBy
        } else {
            nameLabel.text = selectedProfile?.name
        }
        subjectLabel.text = selectedProfile?.firstSub
        priceLabel.text = "\(selectedProfile!.price!)/hr"
        selectedID = currentUserID

        if let profileURL = selectedProfile?.profileImageUrl {
            imageView.loadImageUsingCacheWithUrlString(profileURL)
            imageView.circlerImage()
        }
        
    }


}
