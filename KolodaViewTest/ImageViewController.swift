//
//  ImageViewController.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 03/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var currentMessage : Message = Message()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let messageUrl = currentMessage.imageURL
        imageView.loadImageUsingCacheWithUrlString(messageUrl)
        labelView.text = currentMessage.body

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
