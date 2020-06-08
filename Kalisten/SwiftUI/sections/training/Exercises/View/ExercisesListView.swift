//
//  ExercisesListView.swift
//  Kalisten
//
//  Created by Pedro Solís García on 20/05/2020.
//  Copyright © 2020 Pedro Solís García. All rights reserved.
//

import Foundation
import SwiftUI
import Parse

struct ExercisesListView: View {
  @EnvironmentObject var viewRouter: ViewRouter
  @ObservedObject var model = ExercisesViewModel()
  @Binding var showDetailView: Bool

  var body: some View {
    ZStack {
      Color.kalistenBlack
        .edgesIgnoringSafeArea(.all)
      List {
        ForEach(model.exercises) { exercise in
          NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
            ExerciseItemView(exercise: exercise)
          }
          .listRowInsets(EdgeInsets(top: 2, leading: 20, bottom: 4, trailing: 8))
          .listRowBackground(LinearGradient.spaceGreyGradient)
        }
      }
      .listSeparatorStyle(style: .none)
      .padding(.top, 1)
      .padding(.bottom, 33)
    }
    .navigationBarColor(.darkenGrey).shadow(radius: 2)
    .navigationBarTitle("exercises.title", displayMode: .large)
    .navigationBarItems(trailing:
      Button(action: {
        withAnimation {
          self.showDetailView.toggle()
          self.viewRouter.tabBarDisplay.toggle()
        }
      }, label: {
        Image(systemName: "chevron.down.circle.fill")
          .font(.largeTitle)
          .foregroundColor(.kalistenLightGray)
      })
    )
  }
}

struct ExercisesListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ExercisesListView(showDetailView: .constant(true))
    }
    .environment(\.colorScheme, .dark)
  }
}
