import SwiftUI

struct ListSeparatorModifier: ViewModifier {
  let style: UITableViewCell.SeparatorStyle?
  let color: UIColor?
  
  func body(content: Content) -> some View {
    content
      .onAppear() {
        if let style = self.style {
          UITableView.appearance().separatorStyle = style
        }
        if let color = self.color {
          UITableView.appearance().separatorColor = color
        }
      }
  }
}
 
extension View {
  func listSeparatorStyle(style: UITableViewCell.SeparatorStyle) -> some View {
    ModifiedContent(content: self, modifier: ListSeparatorModifier(style: style, color: nil))
  }
  func listSeparatorColor(color: UIColor) -> some View {
    ModifiedContent(content: self, modifier: ListSeparatorModifier(style: nil, color: color))
  }
}
