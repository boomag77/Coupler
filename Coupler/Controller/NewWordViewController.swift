
import UIKit

class NewWordViewController: UIViewController {
    
    
    
    @IBOutlet weak var newWordTextField: UITextField!
    @IBOutlet weak var meaningTextField: UITextField!
    
    @IBOutlet weak var translationButton: UIButton!
    @IBOutlet weak var glossaryButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var storage: DataStorageManager?
    var editingWord: WordModel?
    var cancelButtonPressed: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let editingWord {
            self.newWordTextField.text = editingWord.name
            self.meaningTextField.text = editingWord.wordDescription
        }
    }
    
    @IBAction func closeView(_ sender: Any) {
        if let _ = editingWord {
            cancelButtonPressed?(true)
        }
        dismiss(animated: true)
    }
    
    @IBAction func addToDictionary(sender: UIButton) {
        guard let name = newWordTextField.text,
              let description = meaningTextField.text
        else {
            return
        }
        guard !self.storage!.isExist(word: name) else {
            print("Word already exists!")
            return
        }
        let newWord = WordModel(name: name,
                                wordDescription: description,
                                storage: "translation",
                                wasRight: nil,
                                wasWrong: nil)
        storage?.addNew(word: newWord)
        if let _ = editingWord {
            cancelButtonPressed?(false)
        }
        dismiss(animated: true)
    }
    
    @IBAction func addToGlossary(sender: UIButton) {
        guard let name = newWordTextField.text,
              let description = meaningTextField.text
        else {
            return
        }
        guard !self.storage!.isExist(word: name) else {
            print("Word already exists!")
            return
        }
        let newWord = WordModel(name: name,
                                wordDescription: description,
                                storage: "glossary",
                                wasRight: nil,
                                wasWrong: nil)
        storage?.addNew(word: newWord)
        if let _ = editingWord {
            cancelButtonPressed?(false)
        }
        dismiss(animated: true)
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
