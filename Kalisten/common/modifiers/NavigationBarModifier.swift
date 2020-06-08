//
//  NavigationBarModifier.swift
//  Kalisten
//
//  Created by Pedro Solís García on 18/05/2020.
//  Copyright © 2020 Pedro Solís García. All rights reserved.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    
  var backgroundColor: UIColor?
  
  init( backgroundColor: UIColor?) {
    self.backgroundColor = backgroundColor
    let navigationBarAppearance = UINavigationBarAppearance()
    navigationBarAppearance.configureWithTransparentBackground()
    navigationBarAppearance.backgroundColor = .clear
    navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//    coloredAppearance.titleTextAttributes = [
//      .font: UIFont.systemFont(ofSize:35, weight: .bold),
//      .foregroundColor: UIColor.white
//    ]
    if let navigationBarFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 35) {
      navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: navigationBarFont]
    }
    
    UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    UINavigationBar.appearance().tintColor = .white

  }
  
  func body(content: Content) -> some View {
    ZStack{
      content
      VStack {
        GeometryReader { geometry in
          Color(self.backgroundColor ?? .clear)
            .frame(height: geometry.safeAreaInsets.top)
            .edgesIgnoringSafeArea(.top)
          Spacer()
        }
      }
    }
  }
}
