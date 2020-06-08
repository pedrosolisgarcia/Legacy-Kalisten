//
//  View+NavBarColor.swift
//  Kalisten
//
//  Created by Pedro Solís García on 18/05/2020.
//  Copyright © 2020 Pedro Solís García. All rights reserved.
//

import SwiftUI

extension View {
  func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
    self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
  }
}
