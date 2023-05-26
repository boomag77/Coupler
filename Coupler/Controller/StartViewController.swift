
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
    @IBOutlet weak var glossaryDictViewLabel: UIView!
    
    @IBOutlet weak var viewButtonLabel: UIButton!
    @IBOutlet weak var trainButtonLabel: UIButton!
    @IBOutlet weak var glossaryViewButton: UIButton!
    @IBOutlet weak var glossaryTrainButton: UIButton!
    
    @IBOutlet weak var translationViewStatLabel: UILabel!
    @IBOutlet weak var glossaryViewStatLabel: UILabel!
    
    var storage: DataStorageManager = StorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attributeView(translationDictViewLabel)
        attributeView(glossaryDictViewLabel)
        attributeButton(viewButtonLabel)
        attributeButton(trainButtonLabel)
        attributeButton(glossaryViewButton)
        attributeButton(glossaryTrainButton)
        
        self.storage.dataRequester = self
        self.updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateData()
    }
    
    private func attributeView(_ label: UIView) {
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.systemGray6.cgColor
        label.layer.cornerRadius = 10
        label.layer.shadowColor = UIColor.systemGray3.cgColor
        label.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        label.layer.shadowOpacity = 1.0
        label.layer.shadowRadius = 1.0
    }
    
    private func attributeButton(_ button: UIButton) {
        button.layer.shadowColor = UIColor.systemGray3.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 1.0
    }
    
    @IBAction func translationViewButtonPressed(_ sender: UIButton) {
        //dismiss(animated: true)
        self.showDictionary(with: .translation)
    }
    
    @IBAction func glossaryViewButtonPressed(_ sender: UIButton) {
        //dismiss(animated: true)
        self.showDictionary(with: .glossary)
    }
    
    @IBAction func translationTrainButtonPressed(_ sender: UIButton) {
        let trainVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "TrainViewController") as! TrainViewController
        trainVC.dictType = .translation
        present(trainVC, animated: true)
    }
    
    @IBAction func glossaryTrainButtonPressed(_ sender: UIButton) {
        let trainVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "TrainViewController") as! TrainViewController
        trainVC.dictType = .glossary
        
        present(trainVC, animated: true)
    }
    
    private func showDictionary(with dictType: StorageType) {
        let dictViewVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "DictViewController") as! DictViewController
        dictViewVC.dictType = dictType
        present(dictViewVC, animated: true)
    }
    
    private func showAddNewWordForm() {
        let addNewWordVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "NewWordViewController") as! NewWordViewController
        addNewWordVC.storage = self.storage
        present(addNewWordVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension StartViewController: DataRequester {
    func updateData() {
        storage.getStats() { stat in
            self.dictionaryLabel.text = "Translation: \(stat.translationCount)"
            self.glossaryLabel.text = "Glossary: \(stat.glossaryCount)"
            self.translationViewStatLabel.text = "memorized 46 / total \(stat.translationCount)"
            self.glossaryViewStatLabel.text = "memorized 46 / total \(stat.glossaryCount)"
        }
    }
}
