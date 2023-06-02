
import UIKit

class TrainViewController: UIViewController, TrainPresenter {
    
    var delegate: ChildViewControllerDelegate?
    var dictType: DictType? {
        didSet {
            self.trainManager = TrainManager(dictType: self.dictType!)
        }
    }
    var cardToShow: WordCard? {
        didSet {
            showCard()
        }
    }
    var isAnswerSelected: Bool = false
    var trainManager: TrainManager?
    
    
    @IBOutlet weak var wordNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        trainManager?.presenter = self
        trainManager?.train()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.childViewControllerDidiDismissed()
    }
    
    func showCard() {
        guard let cardToShow else {
            self.wordNameLabel.text = "no Word to show"
            return
        }
        self.wordNameLabel.text = cardToShow.word.name
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
        cell?.selectionStyle = .none
        var content = cell?.defaultContentConfiguration()
        content?.text = self.cardToShow?.answers[indexPath.row].text
        cell?.contentConfiguration = content
        cell?.backgroundColor = UIColor.clear
        cell?.layer.borderWidth = 0
        
        return cell!
        
    }
    
}

extension TrainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        let selectedAnswer = cardToShow?.answers[indexPath.row]
        if selectedAnswer!.isRight {
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.green.cgColor
            cell.backgroundColor = UIColor.green
            // show next card
            var updatedWord = cardToShow!.word
            updatedWord.wasRight += 1
            let storage = StorageManager()
            storage.edit(wordBeforeEdition: cardToShow!.word, wordAfterEdition: updatedWord)
            
            trainManager?.train()
        } else {
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.red.cgColor
            cell.backgroundColor = UIColor.red
            
            
            
            var updatedWord = cardToShow!.word
            updatedWord.wasWrong += 1
            let storage = StorageManager()
            storage.edit(wordBeforeEdition: cardToShow!.word, wordAfterEdition: updatedWord)
            
            trainManager?.train()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        cell.layer.borderWidth = 0
        cell.backgroundColor = UIColor.clear
    }
}
