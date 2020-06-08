import UIKit

class PlansTableViewCell: UITableViewCell {
  
  @IBOutlet var nameLabel: MarqueeLabel!
  @IBOutlet var tarjetLabel: MarqueeLabel!
  @IBOutlet var levelLabel: MarqueeLabel!
  @IBOutlet var numWeeksLabel: MarqueeLabel!
  @IBOutlet var descriptionView: UITextView!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
