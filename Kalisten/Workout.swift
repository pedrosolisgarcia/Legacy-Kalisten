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
    var numEx:Int = 0
    var exercises:[Exercise] = []
    var intTime:[Int] = [0]
    var totalTime:Int = 0
    var difficulty:Int = 0
    var tarjets = [""]
    var description = ""
    var isCreated = false
    
    init(workId: String, name: String, type: String, family: String, numEx: Int, exercises: [Exercise], intTime: [Int], totalTime: Int, difficulty: Int, tarjets: [String], description: String, isCreated: Bool){
        
        self.workId = workId
        self.name = name
        self.type = type
        self.family = family
        self.numEx = numEx
        self.exercises = exercises
        self.intTime = intTime
        self.totalTime = totalTime
        self.difficulty = difficulty
        self.tarjets = tarjets
        self.description = description
        self.isCreated = isCreated
        
    }
    
    init(pfObject: PFObject) {
        self.workId = pfObject.objectId!
        self.name = pfObject["name"] as! String
        self.type = pfObject["type"] as! String
        self.family = pfObject["family"] as! String
        self.numEx = pfObject["numEx"] as! Int
        self.exercises = pfObject["exercises"] as! [Exercise]
        self.intTime = pfObject["intTime"] as! [Int]
        self.totalTime = pfObject["totalTime"] as! Int
        self.difficulty = pfObject["difficulty"] as! Int
        if pfObject["tarjets"] == nil {self.tarjets = [""]}
        else{self.tarjets = pfObject["tarjets"] as! [String]}
        if pfObject["description"] == nil {self.description = ""}
        else{self.description = pfObject["description"] as! String}
        self.isCreated = pfObject["isCreated"] as! Bool
    }
    
    func toPFObject() -> PFObject {
        let workoutObject = PFObject(className: "Workout")
        workoutObject.objectId = workId
        workoutObject["name"] = name
        workoutObject["type"] = type
        workoutObject["family"] = family
        workoutObject["numEx"] = numEx
        workoutObject["exercises"] = exercises
        workoutObject["intTime"] = intTime
        workoutObject["totalTime"] = totalTime
        workoutObject["difficulty"] = difficulty
        workoutObject["tarjets"] = tarjets
        workoutObject["description"] = description
        workoutObject["isCreated"] = isCreated
        
        return workoutObject
    }
    
}

