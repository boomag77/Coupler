
import UIKit

protocol DataStorageManager {
    //var capacity: StorageCapacity {get set}
    var dataRequester: DataRequester? {get set}
    func getData(storage: StorageType, completion: @escaping ([WordModel]) -> Void)
    func getStats(completion: @escaping (StorageStat) -> Void)
    func addNew(word: WordModel)
    func isExist(word: String) -> Bool
    //func saveDict(dict: [WordModel])
    func delete(_ word: WordModel)
    //func edit(word: WordModel)
}


class StartViewController: UIViewController {
    
    
    
    @IBOutlet weak var dictionaryLabel: UILabel!
    @IBOutlet weak var glossaryLabel: UILabel!
    
    var storage: DataStorageManager = StorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                //dictVC.dict = (self.storage.getData(for: .translation))
                
            } else {
                dictVC.dictType = .glossary
                //dictVC.dict = (self.storage.getData(for: .glossary))
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
