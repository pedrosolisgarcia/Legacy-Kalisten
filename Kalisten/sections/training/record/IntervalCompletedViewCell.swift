import UIKit

class IntervalCompletedViewCell: UITableViewCell {

  @IBOutlet weak var exerciseName: UILabel!
  @IBOutlet weak var setsReps: UILabel!
  @IBOutlet weak var totalEx: UILabel!
  @IBOutlet weak var totalTitle: UILabel!
  @IBOutlet weak var totalReps: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
