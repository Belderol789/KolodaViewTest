//
//  ChatImageTableViewCell.swift
//  
//
//  Created by Kemuel Clyde Belderol on 03/05/2017.
//
//

import UIKit

class ChatImageTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "ChatImageTableViewCell"
    static let cellNib = UINib(nibName: ChatImageTableViewCell.cellIdentifier, bundle: Bundle.main)

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeSentLabel: UILabel!
    @IBOutlet weak var chatImageView: UIImageView!
       override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
