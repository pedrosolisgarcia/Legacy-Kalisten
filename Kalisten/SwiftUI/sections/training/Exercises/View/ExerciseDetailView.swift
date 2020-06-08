//
//  ExerciseDetailView.swift
//  Kalisten
//
//  Created by Pedro Solís García on 31/05/2020.
//  Copyright © 2020 Pedro Solís García. All rights reserved.
//

import SwiftUI

struct ExerciseDetailView: View {
  var exercise: Exercise
  
  @State private var uiImage: UIImage = UIImage(named: "user")!
  
  func getExerciseImage() -> Void {
    if let image = exercise.imageDet {
      image.getDataInBackground(block: { (imageData, error) in
        if let exerciseImageData = imageData {
          self.uiImage = UIImage(data: exerciseImageData)!
        }
      })
    }
  }
  
  func formatArrayToText(_ array: [String]) -> String {
    let arrayTarjet:NSArray = array as NSArray
    return arrayTarjet.componentsJoined(by: ", ").uppercased()
  }

  var body: some View {
    ScrollView {
      VStack {
        Image(uiImage: self.uiImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .clipped()

        Text(exercise.name)
          .font(.system(.title, design: .rounded))
          .fontWeight(.black)

        Spacer()
      }
    }
    .onAppear(perform: getExerciseImage)
  }
}

//struct ExerciseDetailView_Previews: PreviewProvider {
//  static var previews: some View {
//    ExerciseDetailView()
//  }
//}
