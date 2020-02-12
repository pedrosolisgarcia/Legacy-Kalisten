import UIKit

class ExercisesTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: MarqueeLabel!
    @IBOutlet var tarjetLabel: MarqueeLabel!
    @IBOutlet var pqLabel: MarqueeLabel!
    @IBOutlet var levelLabel: MarqueeLabel!
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
