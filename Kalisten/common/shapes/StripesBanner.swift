//
//  LabelStriped.swift
//  Kalisten
//
//  Created by Pedro Solís García on 12/05/2020.
//  Copyright © 2020 Pedro Solís García. All rights reserved.
//

import SwiftUI

struct StripesBanner: Shape {
  func path(in rect: CGRect) -> Path {
    let space: CGFloat = 4
    let space_2: CGFloat = space*2

    var top_leading: CGFloat = rect.size.width + space_2*4
    var top_trailing: CGFloat = rect.size.width + space_2*4
    var bottom_leading: CGFloat = rect.size.width + space_2*2
    var bottom_trailing: CGFloat = rect.size.width + space_2*2
    var path = Path()

    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: top_trailing, y: 0))
    path.addLine(to: CGPoint(x: bottom_trailing, y: rect.size.height))
    path.addLine(to: CGPoint(x: 0, y: rect.size.height))
    
    for _ in 1...25 {
      top_leading = top_trailing + 5
      top_trailing = top_leading + space*2
      bottom_leading = bottom_trailing + 5
      bottom_trailing = bottom_leading + space*2

      path.move(to: CGPoint(x: top_leading, y: 0))
      path.addLine(to: CGPoint(x: top_trailing, y: 0))
      path.addLine(to: CGPoint(x: bottom_trailing, y: rect.size.height))
      path.addLine(to: CGPoint(x: bottom_leading, y: rect.size.height))
    }
    
    return path
  }
}

struct StripesBanner_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test")
          .font(.title)
          .bold()
          .foregroundColor(.white)
          .padding()
          .frame(height: 50)
          .background(StripesBanner().fill(Color.spaceGrey))
    }
}
