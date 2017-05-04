//
//  Message.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 03/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit

class Message {
    var id: Int
    var userID : String
    var userEmail : String
    var body : String
    var imageURL : String
    var timestamp : String
    
    init( ) {
        id = 0
        userID = ""
        userEmail = ""
        body = ""
        imageURL = ""
        timestamp = ""
    }
    
    init(anId : Int, aUserID : String, aUserEmail : String, aBody : String, anImageURL : String, aDate : String) {
        id = anId
        userID = aUserID
        userEmail = aUserEmail
        body = aBody
        imageURL = anImageURL
        timestamp = aDate
    }
}

