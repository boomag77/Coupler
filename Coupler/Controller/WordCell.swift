
import UIKit

class WordCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var trainedLabel: UILabel!
    @IBOutlet weak var checkmarkLabel: UIButton!
    @IBOutlet weak var difficultLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func toggleIsMemorized(_ sender: UIButton) {
        print("mark pressed")
        
    }
    
    
}
