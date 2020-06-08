//
//  ContentView.swift
//  Kalisten
//
//  Created by Pedro Solís García on 22/05/2020.
//  Copyright © 2020 Pedro Solís García. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var viewRouter: ViewRouter
  
  var body: some View {
    Color.darkenGrey
    .edgesIgnoringSafeArea(.all)
      .overlay(
        GeometryReader { geometry in
          VStack(spacing: 0) {
            if self.viewRouter.currentTab == SECTIONS.TRAINING {
              TrainingView()
            }
            if self.viewRouter.currentTab == SECTIONS.NUTRITION {
              NutritionView()
            }
            if self.viewRouter.currentTab == SECTIONS.HOME {
              HomeView()
            }
            if self.viewRouter.currentTab == SECTIONS.CHALLENGE {
              ChallengesView()
            }
            if self.viewRouter.currentTab == SECTIONS.PROFILE {
              ProfileView()
            }
            if self.viewRouter.tabBarDisplay.isShown {
              Spacer(minLength: 0)
              TabBarView(geometry: geometry)
            }
          }
          .edgesIgnoringSafeArea(.bottom)
        }
    )
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(ViewRouter())
//      .environment(\.colorScheme, .dark)
  }
}
