
import UIKit

enum AnswerWas {
    case right
    case wrong
}

protocol CardGeneratorProtocol: AnyObject {
    func generateCard(from dictType: StorageType) -> WordCard?
}

class TrainViewController: UIViewController {
    
    var dictType: StorageType?
    var cardToShow: WordCard?
    
    @IBOutlet weak var wordNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        show()
        
    }
    
    private func getCardToShow() {
        let cardGenerator = CardGenerator(dictType: self.dictType!)
        self.cardToShow = cardGenerator.generateCard()
    }
    
    func show() {
        getCardToShow()
        guard let cardToShow else {
            self.wordNameLabel.text = "no words to show"
            return
        }
        self.wordNameLabel.text = cardToShow.wordName
        self.tableView.reloadData()
    }
    
    private func markAnswer(as answerWas: AnswerWas) {
        
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
