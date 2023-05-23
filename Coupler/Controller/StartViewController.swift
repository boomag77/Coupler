
import UIKit
// View Buttons

protocol DataStorageManager {
    var dataRequester: DataRequester? {get set}
    func getData(storage: StorageType, completion: @escaping ([WordModel]) -> Void)
    func getStats(completion: @escaping (StorageStat) -> Void)
    func addNew(word: WordModel)
    //func isExist(wordName: String, completion: @escaping (WordModel?) -> Void)
    func delete(_ word: WordModel)
    func edit(editingWord: WordModel, editedWord: WordModel)
}

class StartViewController: UIViewController {
    
    @IBOutlet weak var dictionaryLabel: UILabel!
    @IBOutlet weak var glossaryLabel: UILabel!
    
    @IBOutlet weak var translationDictViewLabel: UIView!
    
    @IBOutlet weak var viewButtonLabel: UIButton!
    @IBOutlet weak var trainButtonLabel: UIButton!
    
    
    var storage: DataStorageManager = StorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translationDictViewLabel.layer.borderWidth = 1
        translationDictViewLabel.layer.borderColor = UIColor.systemGray6.cgColor
        translationDictViewLabel.layer.cornerRadius = 10
        translationDictViewLabel.layer.shadowColor = UIColor.systemGray3.cgColor
        translationDictViewLabel.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        translationDictViewLabel.layer.shadowOpacity = 1.0
        translationDictViewLabel.layer.shadowRadius = 1.0
        
        viewButtonLabel.layer.shadowColor = UIColor.systemGray3.cgColor
        viewButtonLabel.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        viewButtonLabel.layer.shadowOpacity = 1.0
        viewButtonLabel.layer.shadowRadius = 1.0
        
        trainButtonLabel.layer.shadowColor = UIColor.systemGray3.cgColor
        trainButtonLabel.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        trainButtonLabel.layer.shadowOpacity = 1.0
        trainButtonLabel.layer.shadowRadius = 1.0
        
        self.storage.dataRequester = self
        self.updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateData()
    }
    
    @IBAction func translationDictButtonPressed(_ sender: UIButton) {
        //dismiss(animated: true)
    }
    
    @IBAction func glossaryDictButtonPressed(_ sender: UIButton) {
        //dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addNewWordVC = segue.destination as? NewWordViewController {
            addNewWordVC.storage = self.storage
        }
        if let dictVC = segue.destination as? DictViewController {
            if segue.identifier == "ShowTranslationDict" {
                dictVC.dictType = .translation
            } else {
                dictVC.dictType = .glossary
            }
        }
    }
}

extension StartViewController: DataRequester {
    func updateData() {
        storage.getStats() { stat in
            self.dictionaryLabel.text = "Translation: \(stat.translationCount)"
            self.glossaryLabel.text = "Glossary: \(stat.glossaryCount)"
        }
    }
}
