import UIKit

class NewWorkoutViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: MarqueeLabel!
    @IBOutlet var thumbnailImageView: UIImageView!
    
    @IBOutlet var plusLabel: UILabel!
    @IBOutlet var addExerciseLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
