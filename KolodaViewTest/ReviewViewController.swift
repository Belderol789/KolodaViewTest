//
//  ReviewViewController.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 08/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Firebase

class ReviewViewController: UIViewController {
    
    var selectedProfile : User?
    var review : String? = ""

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!{
        didSet{
            reviewTextView.borderColor()
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
    

    @IBAction func submitButtonTapped(_ sender: Any) {
        
        review = reviewTextView.text
        
        let userReview : [String : Any] = ["review" : review ?? "No review"]
        let selectedID = selectedProfile?.uid
        
        FIRDatabase.database().reference().child("users").child(selectedID!).updateChildValues(userReview)
        
        
    }
    
    func setupData() {
        nameLabel.text = selectedProfile?.name
        subjectLabel.text = selectedProfile?.firstSub
        priceLabel.text = "\(selectedProfile!.price!)/hr"

        if let profileURL = selectedProfile?.profileImageUrl {
            imageView.loadImageUsingCacheWithUrlString(profileURL)
            imageView.circlerImage()
        }
        
    }


}
