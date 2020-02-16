import UIKit

class ExerciseDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var fieldLabel: UILabel!
    @IBOutlet var valueText: UITextField!
    @IBOutlet var fieldLabel0: UILabel!
    @IBOutlet var valueText0: UITextField!
    @IBOutlet var descriptionText: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
