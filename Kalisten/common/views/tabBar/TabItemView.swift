//
//  TabItemView.swift
//  Kalisten
//
//  Created by Pedro Solís García on 08/05/2020.
//  Copyright © 2020 Pedro Solís García. All rights reserved.
//

import SwiftUI

struct TabItemView: View {
  @EnvironmentObject var viewRouter: ViewRouter

  var section: String
  var geometry: GeometryProxy

  var body: some View {
    VStack {
      Image(section)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding(.horizontal, geometry.size.width/17)
        .frame(width: geometry.size.width/5, height: geometry.size.height/10 - geometry.safeAreaInsets.bottom/3)
        .brightness(self.viewRouter.currentTab == section ? 1 : 0.5)
      Spacer(minLength: geometry.safeAreaInsets.bottom/3)
    }
    .background(self.viewRouter.currentTab == section ? LinearGradient.blueClearGradient : LinearGradient.clear)
    .animation(.default)
    .onTapGesture {
      withAnimation {
        self.viewRouter.currentTab = self.section
      }
    }
  }
}
