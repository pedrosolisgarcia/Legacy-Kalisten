//
//  ExerciseItemView.swift
//  Kalisten
//
//  Created by Pedro Solís García on 30/05/2020.
//  Copyright © 2020 Pedro Solís García. All rights reserved.
//

import SwiftUI

struct ExerciseItemView: View {
  var exercise: Exercise
  
  @State private var uiImage: UIImage = UIImage(named: "user")!
  
  func getExerciseImage() -> Void {
    if let image = exercise.image {
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
    HStack {
      Image(uiImage: self.uiImage)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .padding(4)
        .frame(width: 70, height: 70)
        .background(Color.lightGrey)
        .cornerRadius(4)
      VStack(alignment: .leading, spacing: 0) {
        Text(exercise.name.uppercased())
          .font(.custom("AvenirNextCondensed-DemiBold", size: 28))
          .lineLimit(1)
          .padding(0)
        Text(formatArrayToText(exercise.tarjets))
          .font(.custom("AvenirNextCondensed-DemiBold", size: 16))
          .fontWeight(.light)
          .foregroundColor(.midGrey)
        HStack {
          Text(formatArrayToText(exercise.pq!))
            .fontWeight(.thin)
          Spacer()
          Text(String(Functions.difficultyLevel(difficulty: exercise.difficulty)))
            .fontWeight(.light)
        }
        .font(.custom("AvenirNextCondensed-DemiBold", size: 14))
      }
      .foregroundColor(.white)
      .padding(0)
    }
    .padding(0)
    .onAppear(perform: getExerciseImage)
  }
}
