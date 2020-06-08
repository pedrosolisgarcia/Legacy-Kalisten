//
//  TabBarView.swift
//  Kalisten
//
//  Created by Pedro Solís García on 07/05/2020.
//  Copyright © 2020 Pedro Solís García. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
  @Environment(\.colorScheme) var colorScheme
  @EnvironmentObject var viewRouter: ViewRouter
  
  var geometry: GeometryProxy
  
  var body: some View {
    HStack(spacing: 4) {
      TabItemView(
        section: SECTIONS.TRAINING,
        geometry: geometry
      )

      TabItemView(
        section: SECTIONS.NUTRITION,
        geometry: geometry
      )

      TabItemView(
        section: SECTIONS.HOME,
        geometry: geometry
      )

      TabItemView(
        section: SECTIONS.CHALLENGE,
        geometry: geometry
      )

      TabItemView(
        section: SECTIONS.PROFILE,
        geometry: geometry
      )
    }
    .transition(.move(edge: .bottom))
    .background(Color.darkGrey.shadow(radius: 2))
    .frame(width: geometry.size.width, height: geometry.size.height/10)
  }
}
