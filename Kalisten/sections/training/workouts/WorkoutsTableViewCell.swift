import UIKit

class WorkoutsTableViewCell: UITableViewCell {
  
  @IBOutlet var nameLabel: MarqueeLabel!
  @IBOutlet var familyLabel: MarqueeLabel!
  @IBOutlet var tarjetLabel: MarqueeLabel!
  @IBOutlet var numExlLabel: MarqueeLabel!
  @IBOutlet var timeLabel: MarqueeLabel!
  @IBOutlet var levelLabel: MarqueeLabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
}
