import Foundation
import Combine
import Parse

class ExercisesViewModel: ObservableObject {
    
  @Published var exercises: [Exercise] = []
  
  init() {
    getExercises()
  }
}

extension ExercisesViewModel {
  func getExercises() {
    let query = PFQuery(className: "Exercise")
    //query.order(byAscending: "family")
    query.cachePolicy = PFCachePolicy.networkElseCache
    query.findObjectsInBackground { (objects, error) -> Void in
      
      if let error = error {
        print("Error: \(error) \(error.localizedDescription)")
        return
      }

      if let objects = objects {
        self.exercises = objects.map {
          Exercise(pfObject: $0)
        }
      }
    }
  }
}
