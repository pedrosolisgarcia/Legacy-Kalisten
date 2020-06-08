//
//  trainingView.swift
//  Kalisten
//
//  Created by Pedro Solís García on 07/05/2020.
//  Copyright © 2020 Pedro Solís García. All rights reserved.
//

import SwiftUI

struct TrainingView: View {
  @EnvironmentObject var viewRouter: ViewRouter
  @State var showDetailView = false

  var body: some View {
    NavigationView {
      ZStack {
        Color.darkenGrey
          .edgesIgnoringSafeArea(.all)
        GeometryReader { geometry in
          VStack(spacing: 1) {
            VStack(spacing: 1) {
              HStack(spacing: 1) {
                TrainingItemView(category: "strength")
                TrainingItemView(category: "acrobatics")
              }
              HStack(spacing: 1) {
                TrainingItemView(category: "aerobics")
                TrainingItemView(category: "mobility")
              }
            }
            .frame(height: geometry.size.width)
            VStack(spacing: 1) {
              TrainingItemView(category: "training-plans")
              TrainingItemView(category: "my-workouts")
            }
            .frame(width: geometry.size.width)
          }
          .background(Color.darkenGrey)
        }
        .navigationBarColor(.darkenGrey).shadow(radius: 2)
        .navigationBarTitle("training.title", displayMode: .large)
        .navigationBarItems(trailing:
          Button(action: {
            withAnimation {
              self.showDetailView.toggle()
            }
            self.viewRouter.tabBarDisplay.toggle()
          }, label: {
            Image("exerciseIcon")
              .padding(.bottom, 8)
            })
        )
        .navigationBarHidden(self.showDetailView)
        .modalLink(
          isPresented: $showDetailView,
          destination: {
            ExercisesListView(showDetailView: self.$showDetailView)
        })
      }
    }
  }
}

//struct TrainingView_Previews: PreviewProvider {
//  static var previews: some View {
//    TrainingView().environmentObject(ViewRouter())
//      .environment(\.colorScheme, .dark)
//  }
//}
