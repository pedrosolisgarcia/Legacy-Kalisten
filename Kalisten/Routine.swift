import UIKit
import Parse

class Routine {
    
    var routId = ""
    var name = ""
    var type = ""
    var family = ""
    var workouts = [""]
    var avgTime: Int = 0
    var difficulty:Int = 0
    var improves = ""
    var description: String?
    var isCreated = false
    var user: String?
    
    init(routId: String, name: String, type: String, family: String, workouts: [String],avgTime: Int, difficulty: Int, improves: String, description: String!, isCreated: Bool, user: String!){
        
        self.routId = routId
        self.name = name
        self.type = type
        self.family = family
        self.workouts = workouts
        self.avgTime = avgTime
        self.difficulty = difficulty
        self.improves = improves
        self.description = description
        self.isCreated = isCreated
        self.user = user
        
    }
    
    init(pfObject: PFObject) {
        self.routId = pfObject.objectId!
        self.name = pfObject["name"] as! String
        self.type = pfObject["type"] as! String
        self.family = pfObject["family"] as! String
        self.workouts = pfObject["workouts"] as! [String]
        self.avgTime = pfObject["avgTime"] as! Int
        self.difficulty = pfObject["difficulty"] as! Int
        self.improves = pfObject["improves"] as! String
        self.description = pfObject["description"] as? String
        self.isCreated = pfObject["isCreated"] as! Bool
        self.user = pfObject["user"] as? String
    }
    
    func toPFObject() -> PFObject {
        let routineObject = PFObject(className: "Routine")
        routineObject.objectId = routId
        routineObject["name"] = name
        routineObject["type"] = type
        routineObject["family"] = family
        routineObject["workouts"] = workouts
        routineObject["avgTime"] = avgTime
        routineObject["difficulty"] = difficulty
        routineObject["improves"] = improves
        routineObject["description"] = description
        routineObject["isCreated"] = isCreated
        routineObject["user"] = user
        
        return routineObject
    }
}
