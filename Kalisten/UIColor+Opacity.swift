import UIKit

extension UIColor {
    func opacity(percentage: Int) -> UIColor {
        return self.withAlphaComponent(CGFloat(percentage)/100.0)
    }
}
