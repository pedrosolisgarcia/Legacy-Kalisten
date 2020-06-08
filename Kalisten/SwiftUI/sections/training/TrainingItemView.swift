//
//  TrainingItemView.swift
//  Kalisten
//
//  Created by Pedro Solís García on 19/05/2020.
//  Copyright © 2020 Pedro Solís García. All rights reserved.
//

import SwiftUI

struct TrainingItemView: View {
  var category: String
  
  var body: some View {
    Image(category)
    .resizable()
    .aspectRatio(contentMode: .fill)
    .overlay(
      Rectangle()
        .foregroundColor(.kalistenBlack)
        .opacity(0.5)
        .overlay(
          Text("training.\(category)-section.title"
            .localized()
            .uppercased()
          )
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
        )
    )
  }
}
