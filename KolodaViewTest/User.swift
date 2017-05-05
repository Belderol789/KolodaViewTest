//
//  User.swift
//  KolodaViewTest
//
//  Created by Kemuel Clyde Belderol on 02/05/2017.
//  Copyright © 2017 Burst. All rights reserved.
//

import UIKit

class User {
    var uid: String? //1
    var name: String? //2
    var email: String? //3
    var age: String? //4
    var gender: String? //5
    var desc: String? //6
    var profileImageUrl: String? //7
    var location: String? //8
    var price : String? //9
    var firstSub : String? //10
    var secondSub : String? //11
    var thirdSub : String? //12
    var rating : String? //13
    var role : String? //14
    
    init() {
        uid = ""
        name = ""
        email = ""
        age = ""
        gender = ""
        desc = ""
        profileImageUrl = ""
        location = ""
        price = "50.0Php"
        firstSub = ""
        secondSub = "Optional"
        thirdSub = "Optional"
        rating = ""
        role = ""
    }
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.desc = dictionary["desc"] as? String
        self.age = dictionary["age"] as? String
        self.gender = dictionary["gender"] as? String
        self.location = dictionary["location"] as? String
        self.price = dictionary["price"] as? String
        self.firstSub = dictionary["subject"] as? String
        self.secondSub = dictionary["secondSubject"] as? String
        self.thirdSub = dictionary["thirdSubject"] as? String
        self.rating = dictionary["rating"] as? String
        self.role = dictionary["role"] as? String
        
        //self.numberOfPosts = dictionary["numberOfPosts"] as? String
    }
    
    init(anID: String, anEmail: String, aName: String, anAge: String, aGender: String, aDesc: String, anImgUrl: String, aLocation: String, aPrice: String, aSub: String, aRating: String, aRole : String) {
        uid = anID
        name = aName
        email = anEmail
        age = anAge
        gender = aGender
        desc = aDesc
        profileImageUrl = anImgUrl
        location = aLocation
        price = aPrice
        firstSub = aSub
        rating = aRating
        role = aRole
    }
}
