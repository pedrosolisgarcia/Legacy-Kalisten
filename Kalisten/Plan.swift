//
//  Plan.swift
//  Kalisten
//
//  Created by Pedro Solís García on 16/05/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class Plan {
    
    var planId = ""
    var name = ""
    var place = [""]
    var object = [""]
    var image: PFFile?
    var numWeeks:Int = 0
    var weeks = [""]
    var difficulty:Int = 0
    var tarjet = ""
    var description: String?
    var isCreated = false
    
    init(planId: String, name: String, place: [String], object: [String], image: PFFile!, numWeeks: Int, weeks: [String], difficulty: Int, description: String!, isCreated: Bool){
        
        self.planId = planId
        self.name = name
        self.place = place
        self.object = object
        self.image = image
        self.numWeeks = numWeeks
        self.weeks = weeks
        self.difficulty = difficulty
        self.description = description
        self.isCreated = isCreated
        
    }
    
    init(pfObject: PFObject) {
        self.planId = pfObject.objectId!
        self.name = pfObject["name"] as! String
        self.place = pfObject["place"] as! [String]
        self.object = pfObject["object"] as! [String]
        self.image = pfObject["image"] as? PFFile
        self.numWeeks = pfObject["numWeeks"] as! Int
        self.weeks = pfObject["weeks"] as! [String]
        self.difficulty = pfObject["difficulty"] as! Int
        self.description = pfObject["description"] as? String
        self.isCreated = pfObject["isCreated"] as! Bool
    }
    
    func toPFObject() -> PFObject {
        let planObject = PFObject(className: "Plan")
        planObject.objectId = planId
        planObject["name"] = name
        planObject["place"] = place
        planObject["object"] = object
        planObject["image"] = image
        planObject["numWeeks"] = numWeeks
        planObject["weeks"] = weeks
        planObject["difficulty"] = difficulty
        planObject["description"] = description
        planObject["isCreated"] = isCreated
        
        return planObject
    }
    
}
