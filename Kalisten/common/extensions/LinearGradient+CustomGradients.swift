//
//  LinearGradient+CustomGradients.swift
//  Kalisten
//
//  Created by Pedro Solís García on 12/05/2020.
//  Copyright © 2020 Pedro Solís García. All rights reserved.
//

import SwiftUI

extension LinearGradient {
  static let greyGradient: LinearGradient = LinearGradient(
    gradient: Gradient(colors: [Color.kalistenBlack, Color.darkenGrey]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
  static let spaceGreyGradient: LinearGradient = LinearGradient(
    gradient: Gradient(colors: [Color.kalistenBlack, Color.kalistenDarkGray, Color.kalistenBlack]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
  static let blueGradient: LinearGradient = LinearGradient(
    gradient: Gradient(colors: [Color.estonianBlue, Color.blue]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
  
  static let blueClearGradient: LinearGradient = LinearGradient(
    gradient: Gradient(colors: [Color.estonianBlue, Color.darkenGrey]),
    startPoint: .top,
    endPoint: .bottom
  )
  
  static let clear: LinearGradient = LinearGradient(
    gradient: Gradient(colors: [Color.clear]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
}
