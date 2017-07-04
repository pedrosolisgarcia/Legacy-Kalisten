//
//  Workout.swift
//  Kalisten
//
//  Created by Pedro Solís García on 29/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class Workout {
    
    var workId = ""
    var name = ""
    var type = ""
    var family = ""
    var numSets:Int = 0
    var exercises = [""]
    var intTime:[Double] = [0]
    var totalTime:Int = 0
    var difficulty:Int = 0
    var tarjets: [String]?
    var improves = ""
    var information: [String]?
    var isCreated = false
    var user: String?
    
    init(workId: String, name: String, type: String, family: String, numSets: Int, exercises: [String], intTime: [Double], totalTime: Int, difficulty: Int, tarjets: [String]!, improves: String, information: [String]!, isCreated: Bool, user: String!){
        
        self.workId = workId
        self.name = name
        self.type = type
        self.family = family
        self.numSets = numSets
        self.exercises = exercises
        self.intTime = intTime
        self.totalTime = totalTime
        self.difficulty = difficulty
        self.tarjets = tarjets
        self.improves = improves
        self.information = information
        self.isCreated = isCreated
        self.user = user
        
    }
    
    init(pfObject: PFObject) {
        self.workId = pfObject.objectId!
        self.name = pfObject["name"] as! String
        self.type = pfObject["type"] as! String
        self.family = pfObject["family"] as! String
        self.numSets = pfObject["numSets"] as! Int
        self.exercises = pfObject["exercises"] as! [String]
        self.intTime = pfObject["intTime"] as! [Double]
        self.totalTime = pfObject["totalTime"] as! Int
        self.difficulty = pfObject["difficulty"] as! Int
        self.tarjets = pfObject["tarjets"] as? [String]
        self.improves = pfObject["improves"] as! String
        self.information = pfObject["information"] as? [String]
        self.isCreated = pfObject["isCreated"] as! Bool
        self.user = pfObject["user"] as? String
    }
    
    func toPFObject() -> PFObject {
        let workoutObject = PFObject(className: "Workout")
        workoutObject.objectId = workId
        workoutObject["name"] = name
        workoutObject["type"] = type
        workoutObject["family"] = family
        workoutObject["numSets"] = numSets
        workoutObject["exercises"] = exercises
        workoutObject["intTime"] = intTime
        workoutObject["totalTime"] = totalTime
        workoutObject["difficulty"] = difficulty
        workoutObject["tarjets"] = tarjets
        workoutObject["improves"] = improves
        workoutObject["information"] = information
        workoutObject["isCreated"] = isCreated
        workoutObject["user"] = user
        
        return workoutObject
    }
    
}

