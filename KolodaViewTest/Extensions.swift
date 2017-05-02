//
//  Extensions.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 02/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func circlerImage(){
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
}

