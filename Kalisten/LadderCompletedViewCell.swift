import UIKit

class LadderCompletedViewCell: UITableViewCell {
    
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var maxLadder: UILabel!
    @IBOutlet weak var reps: UILabel!
    @IBOutlet weak var totalTitle: UILabel!
    @IBOutlet weak var totalReps: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
