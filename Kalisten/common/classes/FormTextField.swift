import UIKit

@IBDesignable class FormTextField: UITextField {
  
  func setup() {
    let border = CALayer()
    let width = CGFloat(2.0)
    border.borderColor = UIColor.darkGray.cgColor
    border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
    border.borderWidth = width
//    self.borderStyle = UITextField.BorderStyle(rawValue: 0)!
    self.layer.addSublayer(border)
    self.layer.masksToBounds = true
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
}
