//
//  Record.swift
//  Kalisten
//
//  Created by Pedro Solís García on 15/06/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Parse

class Record {
    
    var recId = ""
    var user = ""
    var workName = ""
    var workType = ""
    var workFamily = ""
    var workDate: Date!
    var workExercises = [""]
    var maxReps = [Int]()
    var countReps = [Int]()
    
    init(recId: String, user: String, workName: String, workType: String, workFamily: String, workDate: Date, workExercises: [String], maxReps: [Int], countReps: [Int]) {
        
        self.recId = recId
        self.user = user
        self.workName = workName
        self.workType = workType
        self.workFamily = workFamily
        self.workDate = workDate
        self.workExercises = workExercises
        self.maxReps = maxReps
        self.countReps = countReps
    }
    
    init(pfObject: PFObject) {
        self.recId = pfObject.objectId!
        self.user = pfObject["user"] as! String
        self.workName = pfObject["workName"] as! String
        self.workType = pfObject["workType"] as! String
        self.workFamily = pfObject["workFamily"] as! String
        self.workDate = pfObject["workDate"] as! Date
        self.workExercises = pfObject["workExercises"] as! [String]
        self.maxReps = pfObject["maxReps"] as! [Int]
        self.countReps = pfObject["countReps"] as! [Int]
    }
    
    func toPFObject() -> PFObject {
        let workoutObject = PFObject(className: "Workout")
        workoutObject.objectId = recId
        workoutObject["user"] = user
        workoutObject["workName"] = workName
        workoutObject["workType"] = workType
        workoutObject["workFamily"] = workFamily
        workoutObject["workDate"] = workDate
        workoutObject["workExercises"] = workExercises
        workoutObject["maxReps"] = maxReps
        workoutObject["countReps"] = countReps
        
        return workoutObject
    }
}
