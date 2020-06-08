//
//  PrimaryButton.swift
//  Kalisten
//
//  Created by Pedro Solís García on 12/05/2020.
//  Copyright © 2020 Pedro Solís García. All rights reserved.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .frame(minWidth: 0, maxWidth: .infinity)
      .padding(12)
      .foregroundColor(.white)
      .background(LinearGradient.blueGradient)
      .font(.title)
      .cornerRadius(2)
  }
}
