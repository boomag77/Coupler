
import UIKit

class NewWordViewController: UIViewController {
    
    @IBOutlet weak var newWordTextField: UITextField!
    @IBOutlet weak var meaningTextField: UITextField!
    
    @IBOutlet weak var translationButton: UIButton!
    @IBOutlet weak var glossaryButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var storage: DataStorageManager?
    var wordBeforeEdition: WordModel?
    var saveButtonPressed: ((WordModel) -> Void)?
    var delegate: ChildViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let wordBeforeEdition {
            self.newWordTextField.text = wordBeforeEdition.name
            self.meaningTextField.text = wordBeforeEdition.wordDescription
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.childViewControllerDidiDismissed()
    }
    
    @IBAction func closeView(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    @IBAction func addToDictionary(sender: UIButton) {
        guard let name = newWordTextField.text,
              let description = meaningTextField.text
        else {
            return
        }
        let newWord = WordModel(name: name,
                                wordDescription: description,
                                storage: "translation"
        )
        guard let wordBeforeEdition else {
            storage?.addNew(word: newWord)
            
            self.dismiss(animated: true)
            return
        }
        self.storage?.edit(wordBeforeEdition: wordBeforeEdition, wordAfterEdition: newWord)
        
        self.dismiss(animated: true)
    }
    
    @IBAction func addToGlossary(sender: UIButton) {
        guard let name = newWordTextField.text,
              let description = meaningTextField.text
        else {
            return
        }
        let newWord = WordModel(name: name,
                                wordDescription: description,
                                storage: "glossary"
        )
        guard let wordBeforeEdition else {
            storage?.addNew(word: newWord)
            self.dismiss(animated: true)
            return
        }
        
        self.storage?.edit(wordBeforeEdition: wordBeforeEdition, wordAfterEdition: newWord)
        self.dismiss(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
