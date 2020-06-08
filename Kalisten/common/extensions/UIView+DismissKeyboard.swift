import UIKit

extension UIView {
  func addDismissKeyboardListener() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    
    tap.cancelsTouchesInView = false
    self.addGestureRecognizer(tap)
  }
}
