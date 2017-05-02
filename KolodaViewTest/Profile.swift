//
//  profile.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 02/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit


class Profile: UIView {
 
    @IBOutlet weak var imageView: UIImageView!
   // @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var topicsLabel: UILabel!
    @IBOutlet weak var textView: UITextView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    private func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        
        // Auto-layout stuff.
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        
        // Show the view.
        addSubview(view)
    }
    
    // Loads a XIB file into a view and returns this view.
    private func viewFromNibForClass() -> UIView {
        
        let bundle = Bundle.main
        let view = bundle.loadNibNamed("Profile", owner: self, options: nil)?.first as! UIView
        //let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        //let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        print(123)

        return view
    }

   

}
