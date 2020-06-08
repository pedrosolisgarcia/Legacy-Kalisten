import UIKit

class TrainingCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet var categoryLabel: UILabel!
  
  override var isSelected: Bool {
    didSet {
      self.contentView.backgroundColor = isSelected ? .lightGrey : .estonianBlue
    }
  }
}
