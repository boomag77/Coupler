
import UIKit
// View Buttons

protocol ChildViewControllerDelegate: AnyObject {
    func childViewControllerDidiDismissed()
}

protocol DataStorageManager: AnyObject {
    var dataRequester: DataRequester? {get set}
    func getData(for dict: DictType, completion: @escaping ([WordModel]) -> Void)
    func getStats(completion: @escaping (StorageStat) -> Void)
    func saveNew(word: WordModel)
    //func isExist(wordName: String, completion: @escaping (WordModel?) -> Void)
    func delete(_ word: WordModel)
    func edit(wordBeforeEdition: WordModel, wordAfterEdition: WordModel)
}

class StartViewController: UIViewController, ChildViewControllerDelegate {
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateData()
    }
    
    
    func childViewControllerDidiDismissed() {
        viewWillAppear(false)
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
        self.showDictionary(with: .translation)
    }
    
    @IBAction func glossaryViewButtonPressed(_ sender: UIButton) {
        self.showDictionary(with: .glossary)
    }
    
    @IBAction func translationTrainButtonPressed(_ sender: UIButton) {
        let trainVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "TrainViewController") as! TrainViewController
        trainVC.dictType = .translation
        trainVC.delegate = self
        present(trainVC, animated: true)
        
    }
    
    @IBAction func glossaryTrainButtonPressed(_ sender: UIButton) {
        let trainVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "TrainViewController") as! TrainViewController
        trainVC.dictType = .glossary
        trainVC.delegate = self
        present(trainVC, animated: true)
    }
    
    private func showDictionary(with dictType: DictType) {
        let dictViewVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "DictViewController") as! DictViewController
        dictViewVC.dictType = dictType
        dictViewVC.delegate = self
        present(dictViewVC, animated: true)
    }
    
    private func showAddNewWordForm() {
        let saveNewWordVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "NewWordViewController") as! NewWordViewController
        saveNewWordVC.delegate = self
        saveNewWordVC.storage = self.storage
        present(saveNewWordVC, animated: true)
    }
    
    @IBAction func saveNewButtonPressed(_ sender: UIButton) {
        self.showAddNewWordForm()
    }
    
}

extension StartViewController: DataRequester {
    func updateData() {
        print("startVC - update")
        storage.getStats() { stat in
            self.dictionaryLabel.text = "Translation: \(stat.translationCount)"
            self.glossaryLabel.text = "Glossary: \(stat.glossaryCount)"
            self.translationViewStatLabel.text = "memorized 46 / total \(stat.translationCount)"
            self.glossaryViewStatLabel.text = "memorized 46 / total \(stat.glossaryCount)"
        }
    }
}
