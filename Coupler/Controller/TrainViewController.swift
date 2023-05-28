
import UIKit

enum AnswerWas {
    case right
    case wrong
}

class TrainViewController: UIViewController, TrainPresenter {
    
    var dictType: StorageType?
    var cardToShow: WordCard?
    
    @IBOutlet weak var wordNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        let trainManager = TrainManager(dictType: self.dictType!)
        trainManager.presenter = self
        trainManager.train()
    }
    
    func showCard() {
        guard let cardToShow else {
            self.wordNameLabel.text = "no Word to show"
            return
        }
        self.wordNameLabel.text = cardToShow.wordName
        self.tableView.reloadData()
    }

}

extension TrainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cardToShow else {
            return 0
        }
        return cardToShow.answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell")
        var content = cell?.defaultContentConfiguration()
        content?.text = cardToShow?.answers[indexPath.row]
        cell?.contentConfiguration = content
        
        return cell!
    }
    
}
