//
//  Extensions.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 02/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func circlerImage(){
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
    
    func borderColors() {
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.borderWidth = 1.0
    }
    
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        
        //self.image = nil //it wasn't working before that !!
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }

    
}

extension UIButton {
    func curveEdges() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    func circlerImage(){
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
    func borderColors() {
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.borderWidth = 1.0
    }


}

extension UILabel {
    func curveEdges() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    func borderColor() {
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.borderWidth = 1.0
    }
}

extension UITextField {
    func borderColor() {
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.borderWidth = 1.0
    }
}

extension UITextView {
    func curveEdges() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    func borderColor() {
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.borderWidth = 1.0
    }
    
    func textViewDidBeginEditing(textView: UITextView, text: String){
        if(textView.text == text) {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView, text: String) {
        if (textView.text == "") {
            textView.text = text
            textView.textColor = .lightGray
        }
        textView.becomeFirstResponder()
    }
    

}

