//
//  ViewRouter.swift
//  Kalisten
//
//  Created by Pedro Solís García on 07/05/2020.
//  Copyright © 2020 Pedro Solís García. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class ViewRouter: ObservableObject {
    
  @Published var currentTab: String = SECTIONS.HOME
  @Published var tabBarDisplay: DisplayEnum = .show
}
