//
//  Chat.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 03/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit

class Chat {
    var id: String
    var userIds : Array<String>
    var userEmails : Array<String>
    var userScreenNames : Array<String>
    var userImages : Array<String>
    var messages : Array<Message>
    
    init( ) {
        id = ""
        userIds = [String]()
        userEmails = [String]()
        userScreenNames = [String]()
        userImages = [String]()
        messages = [Message]()
    }
    
    init(anId : String, userOneId: String, userOneEmail: String, userOneScreenName: String, userOneImageURL: String, userTwoId: String, userTwoEmail: String, userTwoScreenName: String, userTwoImageURL: String) {
        id = anId
        userIds = [userOneId, userTwoId]
        userEmails = [userOneEmail, userTwoEmail]
        userScreenNames = [userOneScreenName, userTwoScreenName]
        userImages = [userOneImageURL, userTwoImageURL]
        messages = [Message]()
    }
}

