//
//  UserTableViewCell.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 03/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "UserTableViewCell"
    static let cellNib = UINib(nibName: UserTableViewCell.cellIdentifier, bundle: Bundle.main)
    
    
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.circlerImage()
            profileImage.borderColors()
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var priceRangeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    
    
}
