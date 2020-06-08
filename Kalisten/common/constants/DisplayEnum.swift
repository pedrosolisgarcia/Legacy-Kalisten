import Foundation

enum DisplayEnum {
  case show
  case hide
  
  var isShown: Bool {
    self == .show
  }
  var isHidden: Bool {
    self == .hide
  }

  mutating func toggle() -> Void {
    switch self {
    case .show:
      self = .hide
    case .hide:
      self = .show
    }
  }
  
  var currentState: Bool {
    switch self {
    case .show:
      return true
    case .hide:
      return false
    }
  }
}
