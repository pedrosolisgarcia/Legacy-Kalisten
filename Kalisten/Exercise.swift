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
    var place = [""]
    var pq = [""]
    var object = [""]
    var image: PFFile?
    var difficulty:Int = 0
    var tarjets = [""]
    var description = ""
    var isCreated = false
    
    init(exId: String, name: String, type: String, family: [String], place: [String], pq: [String], object: [String], image: PFFile!, difficulty: Int, tarjets: [String], description: String, isCreated: Bool){
        
        self.exId = exId
        self.name = name
        self.type = type
        self.family = family
        self.place = place
        self.pq = pq
        self.object = object
        self.image = image
        self.difficulty = difficulty
        self.tarjets = tarjets
        self.description = description
        self.isCreated = isCreated
        
    }
    
    init(pfObject: PFObject) {
        self.exId = pfObject.objectId!
        self.name = pfObject["name"] as! String
        self.type = pfObject["type"] as! String
        self.family = pfObject["family"] as! [String]
        self.place = pfObject["place"] as! [String]
        self.pq = pfObject["pq"] as! [String]
        if pfObject["object"] == nil {self.object = [""]}
        else{self.object = pfObject["object"] as! [String]}
        self.image = pfObject["image"] as? PFFile
        self.difficulty = pfObject["difficulty"] as! Int
        self.tarjets = pfObject["tarjets"] as! [String]
        if pfObject["description"] == nil {self.description = ""}
        else{self.description = pfObject["description"] as! String}
        self.isCreated = pfObject["isCreated"] as! Bool
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
        exerciseObject["difficulty"] = difficulty
        exerciseObject["tarjets"] = tarjets
        exerciseObject["description"] = description
        exerciseObject["isCreated"] = isCreated
        
        return exerciseObject
    }

}
