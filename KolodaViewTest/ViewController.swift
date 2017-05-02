//
//  ViewController.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 02/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit
import Koloda


class ViewController: UIViewController {
    
    @IBOutlet weak var kolodaView: KolodaView!
    var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.delegate = self
        kolodaView.dataSource = self
        
        for _ in 0...10 {
            images.append(UIImage(named: "thumbsDown")!)
            images.append(UIImage(named: "thumbsUp")!)
            
        }
        
        kolodaView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    


}

extension ViewController: KolodaViewDelegate {
//    func kolodaDidRunOutOfCards(koloda: KolodaView) {
//        dataSource.reset()
//    }
    
    func koloda(koloda: KolodaView, didSelectCardAt index: Int) {
        print("Select at \(index)")
    }
}

extension ViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return images.count
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let blueView = profile(frame: koloda.frame)
        blueView.nameLabel.text = "Hello World"
        return blueView

//        return UIImageView(image: images[index])
    }
    
       // return UIImageView(image: images[index])
    
//    func koloda(koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        return NSBundle.mainBundle().loadNibNamed("OverlayView",
//                                                  owner: self, options: nil)[0] as? OverlayView
//    }

}
