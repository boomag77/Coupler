
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
    var wordsToTrain: [WordModel]?
    
    @IBOutlet weak var wordNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        self.showCard()
        //wordNameLabel.text = storageType?.rawValue
        //self.trainManager?.start()
        
        //showCard(for: card)
    }
    
    func showCard() {
        
        let cardGenerator = CardGenerator(dictType: self.dictType!, words: self.wordsToTrain!)
        self.cardToShow = cardGenerator.generateCard()
        tableView.dataSource = self
        wordNameLabel.text = cardToShow?.wordName
        
    }
    
    private func isRight(answer: Int) -> Bool {
        
        return true
    }
    
    private func markAnswer(as answerWas: AnswerWas) {
        
    }

}

extension TrainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardToShow!.answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell")
        var content = cell?.defaultContentConfiguration()
        content?.text = cardToShow?.answers[indexPath.row]
        cell?.contentConfiguration = content
        
        return cell!
    }
    
}
