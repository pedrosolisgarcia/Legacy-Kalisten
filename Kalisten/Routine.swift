//
//  Routine.swift
//  Kalisten
//
//  Created by Pedro Solís García on 16/05/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class Routine {
    
    var routId = ""
    var name = ""
    var type = ""
    var family = ""
    var numDays:Int = 0
    var workouts = [""]
    var difficulty:Int = 0
    var tarjets = [""]
    var improves = ""
    var description: String?
    var isCreated = false
    
    init(routId: String, name: String, type: String, family: String, numDays: Int, workouts: [String],difficulty: Int, description: String!, isCreated: Bool){
        
        self.routId = routId
        self.name = name
        self.type = type
        self.family = family
        self.numDays = numDays
        self.workouts = workouts
        self.difficulty = difficulty
        self.description = description
        self.isCreated = isCreated
        
    }
    
    init(pfObject: PFObject) {
        self.routId = pfObject.objectId!
        self.name = pfObject["name"] as! String
        self.type = pfObject["type"] as! String
        self.family = pfObject["family"] as! String
        self.numDays = pfObject["numDays"] as! Int
        self.workouts = pfObject["workouts"] as! [String]
        self.difficulty = pfObject["difficulty"] as! Int
        self.description = pfObject["description"] as? String
        self.isCreated = pfObject["isCreated"] as! Bool
    }
    
    func toPFObject() -> PFObject {
        let routineObject = PFObject(className: "Routine")
        routineObject.objectId = routId
        routineObject["name"] = name
        routineObject["type"] = type
        routineObject["family"] = family
        routineObject["numDays"] = numDays
        routineObject["workouts"] = workouts
        routineObject["difficulty"] = difficulty
        routineObject["tarjets"] = tarjets
        routineObject["improves"] = improves
        routineObject["description"] = description
        routineObject["isCreated"] = isCreated
        
        return routineObject
    }
}
