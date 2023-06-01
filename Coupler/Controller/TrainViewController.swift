
import UIKit

class TrainViewController: UIViewController, TrainPresenter {
    
    var delegate: ChildViewControllerDelegate?
    var dictType: DictType?
    var cardToShow: WordCard? {
        didSet {
            showCard()
        }
    }
    var isAnswerSelected: Bool = false
    
    
    @IBOutlet weak var wordNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        let trainManager = TrainManager(dictType: self.dictType!)
        trainManager.presenter = self
        trainManager.train()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.childViewControllerDidiDismissed()
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
        content?.text = self.cardToShow?.answers[indexPath.row].text
        if isAnswerSelected {
            cell?.layer.borderWidth = 1
        }
        cell?.contentConfiguration = content
        
        return cell!
    }
    
}

//extension TrainViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedAnswer = cardToShow?.answers[indexPath.row]
//        isAnswerSelected = true
//        
//        
//    }
//}
