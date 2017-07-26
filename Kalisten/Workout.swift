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
    var category = ""
    var type = ""
    var numSets:Int = 0
    var exercises = [""]
    var intTime:[Double] = [0]
    var repetitions: [Int]?
    var totalTime:Int = 0
    var difficulty:Int = 0
    var tarjets: [String]?
    var improves = ""
    var information: [String]?
    var isCreated = false
    var user: String?
    
    init(workId: String, name: String, category: String, type: String, numSets: Int, exercises: [String], intTime: [Double], repetitions: [Int]!, totalTime: Int, difficulty: Int, tarjets: [String]!, improves: String, information: [String]!, isCreated: Bool, user: String!){
        
        self.workId = workId
        self.name = name
        self.category = category
        self.type = type
        self.numSets = numSets
        self.exercises = exercises
        self.repetitions = repetitions
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
        self.category = pfObject["category"] as! String
        self.type = pfObject["type"] as! String
        self.numSets = pfObject["numSets"] as! Int
        self.exercises = pfObject["exercises"] as! [String]
        self.repetitions = pfObject["repetitions"] as? [Int]
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
        workoutObject["category"] = category
        workoutObject["type"] = type
        workoutObject["numSets"] = numSets
        workoutObject["exercises"] = exercises
        workoutObject["repetitions"] = repetitions
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

