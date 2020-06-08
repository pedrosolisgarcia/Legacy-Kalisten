//
//  TabBarViewTest.swift
//  KalistenTests
//
//  Created by Pedro Solís García on 11/05/2020.
//  Copyright © 2020 Pedro Solís García. All rights reserved.
//

import XCTest
import ViewInspector
@testable import Kalisten

extension TabBarView: Inspectable {}
extension TabItemView: Inspectable {}

final class TabBarViewTests: XCTestCase {
  
  var tabBar = TabBarView()
  var container: InspectableView<ViewType.HStack>? = nil
  
  func testMainViewIsNotNil() throws {
    let mainView = try tabBar.inspect().navigationView()
    XCTAssertNotNil(mainView)
  }
  
  func testTrainingTab() throws {
    container = try tabBar.inspect().navigationView().geometryReader(0).vStack().hStack(3)
    
    XCTAssertNotNil(container)
    
    let trainingTab = try container![0].view(TabItemView.self).vStack().image(0).imageName()
    
    XCTAssertEqual(trainingTab, "training")
  }
  
  func testNutritionTab() throws {
    container = try tabBar.inspect().navigationView().geometryReader(0).vStack().hStack(3)
    let nutritionTab = try container![1].view(TabItemView.self).vStack().image(0).imageName()
    
    XCTAssertEqual(nutritionTab, "nutrition")
  }
  
  func testPlanTab() throws {
    container = try tabBar.inspect().navigationView().geometryReader(0).vStack().hStack(3)
    let planTab = try container![2].view(TabItemView.self).vStack().image(0).imageName()
    
    XCTAssertEqual(planTab, "plan")
  }
  
  func testChallengeTab() throws {
    container = try tabBar.inspect().navigationView().geometryReader(0).vStack().hStack(3)
    let challengeTab = try container![3].view(TabItemView.self).vStack().image(0).imageName()
    
    XCTAssertEqual(challengeTab, "challenge")
  }
  
  func testProfileTab() throws {
    container = try tabBar.inspect().navigationView().geometryReader(0).vStack().hStack(3)
    let profileTab = try container![4].view(TabItemView.self).vStack().image(0).imageName()
    
    XCTAssertEqual(profileTab, "profile")
  }
}
