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
    var familyIcon: PFFile?
    var numEx:Int = 0
    var numSets:Int = 0
    var exercises = [""]
    var intTime:[Int] = [0]
    var totalTime:Int = 0
    var difficulty:Int = 0
    var tarjets = [""]
    var improves = ""
    var description = ""
    var isCreated = false
    
    init(workId: String, name: String, type: String, family: String, familyIcon: PFFile!, numEx: Int, numSets: Int, exercises: [String], intTime: [Int], totalTime: Int, difficulty: Int, tarjets: [String], improves: String, description: String, isCreated: Bool){
        
        self.workId = workId
        self.name = name
        self.type = type
        self.family = family
        self.familyIcon = familyIcon
        self.numEx = numEx
        self.numSets = numSets
        self.exercises = exercises
        self.intTime = intTime
        self.totalTime = totalTime
        self.difficulty = difficulty
        self.tarjets = tarjets
        self.improves = improves
        self.description = description
        self.isCreated = isCreated
        
    }
    
    init(pfObject: PFObject) {
        self.workId = pfObject.objectId!
        self.name = pfObject["name"] as! String
        self.type = pfObject["type"] as! String
        self.family = pfObject["family"] as! String
        self.familyIcon = pfObject["familyIcon"] as? PFFile
        self.numEx = pfObject["numEx"] as! Int
        self.numSets = pfObject["numSets"] as! Int
        self.exercises = pfObject["exercises"] as! [String]
        self.intTime = pfObject["intTime"] as! [Int]
        self.totalTime = pfObject["totalTime"] as! Int
        self.difficulty = pfObject["difficulty"] as! Int
        if pfObject["tarjets"] == nil {self.tarjets = [""]}
        else{self.tarjets = pfObject["tarjets"] as! [String]}
        self.improves = pfObject["improves"] as! String
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
        workoutObject["familyIcon"] = familyIcon
        workoutObject["numEx"] = numEx
        workoutObject["numSets"] = numSets
        workoutObject["exercises"] = exercises
        workoutObject["intTime"] = intTime
        workoutObject["totalTime"] = totalTime
        workoutObject["difficulty"] = difficulty
        workoutObject["tarjets"] = tarjets
        workoutObject["improves"] = improves
        workoutObject["description"] = description
        workoutObject["isCreated"] = isCreated
        
        return workoutObject
    }
    
}

