import UIKit

class WorkoutDetailTableViewCell: UITableViewCell {
  
  @IBOutlet var nameLabel: MarqueeLabel!
  @IBOutlet var thumbnailImageView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
