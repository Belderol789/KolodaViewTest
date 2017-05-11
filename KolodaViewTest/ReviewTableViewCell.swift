//
//  ReviewTableViewCell.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 09/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Cosmos

class ReviewTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "ReviewTableViewCell"
    static let cellNib = UINib(nibName: ReviewTableViewCell.cellIdentifier, bundle: Bundle.main)

    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var reviewTextView: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
