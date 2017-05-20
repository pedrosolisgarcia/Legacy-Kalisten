//
//  Exercise.swift
//  Kalisten
//
//  Created by Pedro Solís García on 20/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class Exercise {
    
    var exId = ""
    var name = ""
    var type = ""
    var family = [""]
    var place: [String]?
    var pq: [String]?
    var object: [String]?
    var image: PFFile?
    var imageDet: PFFile?
    var difficulty:Int = 0
    var tarjets = [""]
    var description: String?
    
    init(exId: String, name: String, type: String, family: [String], place: [String]!, pq: [String]!, object: [String]!, image: PFFile!, imageDet: PFFile!, difficulty: Int, tarjets: [String], description: String!){
        
        self.exId = exId
        self.name = name
        self.type = type
        self.family = family
        self.place = place
        self.pq = pq
        self.object = object
        self.image = image
        self.imageDet = imageDet
        self.difficulty = difficulty
        self.tarjets = tarjets
        self.description = description
        
    }
    
    init(pfObject: PFObject) {
        self.exId = pfObject.objectId!
        self.name = pfObject["name"] as! String
        self.type = pfObject["type"] as! String
        self.family = pfObject["family"] as! [String]
        self.place = pfObject["place"] as? [String]
        self.pq = pfObject["pq"] as? [String]
        self.object = pfObject["object"] as? [String]
        self.image = pfObject["image"] as? PFFile
        self.imageDet = pfObject["imageDet"] as? PFFile
        self.difficulty = pfObject["difficulty"] as! Int
        self.tarjets = pfObject["tarjets"] as! [String]
        self.description = pfObject["description"] as? String
    }
    
    func toPFObject() -> PFObject {
        let exerciseObject = PFObject(className: "Exercise")
        exerciseObject.objectId = exId
        exerciseObject["name"] = name
        exerciseObject["type"] = type
        exerciseObject["family"] = family
        exerciseObject["place"] = place
        exerciseObject["pq"] = pq
        exerciseObject["object"] = object
        exerciseObject["image"] = image
        exerciseObject["imageDet"] = imageDet
        exerciseObject["difficulty"] = difficulty
        exerciseObject["tarjets"] = tarjets
        exerciseObject["description"] = description
        
        return exerciseObject
    }
    
}
