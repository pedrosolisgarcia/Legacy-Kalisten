//
//  ContentView.swift
//  Kalisten
//
//  Created by Pedro Solís García on 07/05/2020.
//  Copyright © 2020 Pedro Solís García. All rights reserved.
//

import SwiftUI

struct HomeView: View {
  @EnvironmentObject var viewRouter: ViewRouter

  var body: some View {
    NavigationView {
      ZStack {
        Color.darkenGrey
          .edgesIgnoringSafeArea(.all)
        GeometryReader { geometry in
          VStack {
            VStack {
              HStack {
                Text("my-plan.training.training-label.text")
                  .font(.title)
                  .fontWeight(.bold)
                  .padding(.leading, 12)
                  .frame(height: 45)
                  .background(StripesBanner().fill(Color.darkGrey))
                Spacer()
              }
              VStack {
                VStack {
                  HStack {
                    Text("my-plan.training.workout-selected.title")
                      .fontWeight(.bold)
                    Text("my-plan.training.content-default")
                    Spacer()
                    Text("my-plan.training.week-count.title")
                      .fontWeight(.bold)
                    Text("0")
                  }
                  .font(.body)
                  VStack {
                    Spacer()
                    HStack {
                      Text("my-plan.training.today.title")
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .padding(.top)
                      Spacer()
                    }
                    Text(
                      "my-plan.training.today.nothing-sheduled"
                        .localized()
                        .uppercased()
                    )
                      .font(.largeTitle)
                      .fontWeight(.light)
                    Spacer()
                  }
                  HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                      HStack {
                        Text("my-plan.training.warm-up.title")
                          .fontWeight(.bold)
                        Text("my-plan.training.content-default")
                      }
                      HStack {
                        Text("my-plan.training.cool-down.title")
                          .fontWeight(.bold)
                        Text("my-plan.training.content-default")
                      }
                    }
                    Spacer()
                    HStack {
                      Text("my-plan.training.total-time.title")
                        .fontWeight(.bold)
                      Text("0")
                    }
                  }
                  .font(.subheadline)
                }
                .padding(.bottom, 12)
                Button(action: {
                  self.viewRouter.currentTab = SECTIONS.TRAINING
                }) {
                  Text(
                    "my-plan.training.training-button.title-select"
                      .localized()
                      .uppercased()
                  )
                    .font(.system(size: 20))
                    .fontWeight(.heavy)
                }
                .buttonStyle(PrimaryButtonStyle())
              }
              .padding(8)
            }
            .frame(width: geometry.size.width, height: geometry.size.height/2)
            .background(LinearGradient.greyGradient)
            VStack {
              HStack {
                Text("my-plan.nutrition.nutrition-label.text")
                  .font(.title)
                  .fontWeight(.bold)
                  .padding(.leading, 12)
                  .frame(height: 45)
                  .background(StripesBanner().fill(Color.darkGrey))
                Spacer()
              }
              VStack {
                VStack {
                  HStack {
                    Text("my-plan.nutrition.goal.title")
                      .fontWeight(.bold)
                    Text("my-plan.training.content-default")
                    Spacer()
                  }
                  .font(.body)
                  VStack {
                    Spacer()
                    VStack {
                      Text("my-plan.nutrition.calorie-intake.title")
                        .font(.subheadline)
                        .bold()
                      ZStack {
                        ZStack(alignment: .leading) {
                          RoundedRectangle(cornerRadius: 10)
                            .fill(Color.kalistenDarkGray)
                            .frame(width: geometry.size.width/1.25, height: 20)
                          RoundedRectangle(cornerRadius: 10)
                            .fill(LinearGradient.blueGradient)
                            .frame(width: 20, height: 20)
                        }
                        Text("0/0 kcal")
                          .font(.footnote)
                          .bold()
                      }
                      HStack {
                        Text("my-plan.nutrition.calorie-intake.proteins")
                        Text("my-plan.nutrition.calorie-intake.carbs")
                        Text("my-plan.nutrition.calorie-intake.fats")
                        Text("my-plan.nutrition.water-intake.water")
                      }
                      .font(.footnote)
                    }
                    Spacer()
                  }
                  HStack(alignment: .bottom) {
                    HStack {
                      Text("my-plan.nutrition.last-meal.title")
                        .fontWeight(.bold)
                      Text("00:00")
                    }
                    Spacer()
                    HStack {
                      Text("my-plan.nutrition.next-meal.title")
                        .fontWeight(.bold)
                      Text("00:00")
                    }
                  }
                  .font(.subheadline)
                }
                .padding(.bottom, 12)
                Button(action: {
                  self.viewRouter.currentTab = SECTIONS.NUTRITION
                }) {
                  Text(
                    "my-plan.nutrition.nutrition-button.title-select"
                      .localized()
                      .uppercased()
                  )
                    .font(.system(size: 20))
                    .fontWeight(.heavy)
                }
                .buttonStyle(PrimaryButtonStyle())
              }
              .padding(8)
            }
            .frame(width: geometry.size.width, height: geometry.size.height/2)
            .background(LinearGradient.greyGradient)
          }
          .frame(width: geometry.size.width, height: geometry.size.height)
          .foregroundColor(.white)
          .navigationBarColor(.darkenGrey).shadow(radius: 2)
          .navigationBarTitle(Text("Kalisten"), displayMode: .inline)
          .navigationBarItems(leading:
            Button(action: {
            }, label: {
              Image("calendarIcon")
                .foregroundColor(.white)
                .padding(.bottom, 8)
            })
          )
        }
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
      .environment(\.colorScheme, .dark)
  }
}
