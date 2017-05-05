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

    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.borderColors()
        }
    }
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.curveEdges()
            textView.borderColor()
            textView.isUserInteractionEnabled = false
        }
    }
        @IBOutlet weak var button: UIButton!{
        didSet{
            button.circlerImage()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let messageUrl = currentMessage.imageURL
        imageView.loadImageUsingCacheWithUrlString(messageUrl)
        textView.text = "sent by: \(currentMessage.userEmail) on \(currentMessage.timestamp)"

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)

        
    }


}
