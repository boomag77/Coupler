
import UIKit

class DictViewController: UIViewController {
    
    enum SortingCondition: Int {
        case alphabet = 0
        case complexity
        case date
        case memorized
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalNumberLabel: UILabel!
    @IBOutlet weak var memorizedNumberLabel: UILabel!
    @IBOutlet weak var sortingControlLabel: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var dict: [WordModel] = []
    var storage: DataStorageManager = StorageManager()
    var dictType: StorageType?
    lazy var memorizedCount = {
        var count = 0
        for word in dict {
            var w = word
            if w.memorized == true {
                count += 1
            }
        }
        return count
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storage.dataRequester = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "WordCell", bundle: nil),
                           forCellReuseIdentifier: "WordCell"
        )
        self.updateData()
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateData()
    }
    
    @IBAction func closeButtonPresent(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func sortConditionSelected(_ sender: UISegmentedControl) {
        sortDisplaiedDict(condition: sender.selectedSegmentIndex)
        tableView.reloadData()
    }
    
    @IBAction func sortConditionPressed(_ sender: UISegmentedControl) {
        
    }
    
    private func updateTitle() {
        if self.dictType == .translation {
            titleLabel.text = "translation dictionary".uppercased()
        } else {
            titleLabel.text = "glossary dictionary".uppercased()
        }
        if dict.count > 0 {
            self.totalNumberLabel.text = "\(dict.count)"
            self.memorizedNumberLabel.text = "\(self.memorizedCount)"
            
        } else {
            self.totalNumberLabel.text = "0"
            self.memorizedNumberLabel.text = "0"
        }
    }
    
    private func sortDisplaiedDict(condition: Int) {
        switch condition {
        case 0:
            if sortingControlLabel.titleForSegment(at: condition) == "A..Z" {
                dict.sort {$0.name < $1.name}
                sortingControlLabel.setTitle("Z..A", forSegmentAt: condition)
            } else {
                dict.sort {$0.name > $1.name}
                sortingControlLabel.setTitle("A..Z", forSegmentAt: condition)
            }
            
        case 1:
            dict.sort {$0.wordDescription < $1.wordDescription}
            print("sorting by date")
        case 2:
            dict.sort {$0.complexity > $1.complexity}
            print("sorting by complexity")
        default:
            //dict.sort {$0.memorized > $1.memorized}
            print("sorting by memorized")
        }
    }
  
}

//MARK: -- TableView DataSource
extension DictViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let word = dict[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell") as! WordCell
        cell.nameLabel.text = word.name
        cell.trainedLabel.text = "trained \(word.trainedCount) times"
        cell.difficultLabel.text = "difficalty \(word.complexity)%"
        if word.memorized {
            cell.checkmarkLabel.imageView?.tintColor = .systemGreen
        } else {
            cell.checkmarkLabel.imageView?.tintColor = .systemGray3
        }
        
        return cell
    }
}

extension DictViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = dict[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let wordVC = sb.instantiateViewController(identifier: "WordViewController") as! WordViewController
        wordVC.word = word
        //wordVC.modalPresentationStyle = .overCurrentContext
        //wordVC.modalTransitionStyle = .crossDissolve
        wordVC.modalPresentationStyle = .formSheet // or .pageSheet
        //wordVC.preferredContentSize = CGSize(width: 100, height: 120)
        present(wordVC, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let word = dict[indexPath.row]
        let actionDelete = UIContextualAction(
            style: .destructive,
            title: nil) { _,_,_ in
                self.storage.delete(word)
            }
        
        actionDelete.image = UIImage(systemName: "trash")
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let word = dict[indexPath.row]
        let actionEdit = UIContextualAction(style: .normal, title: nil) { _,_,_ in
            self.showEditForm(editingWord: word)
        }
        
        actionEdit.backgroundColor = .systemGreen
        actionEdit.image = UIImage(systemName: "pencil")
        //actionArchive.backgroundColor = .blue
        //actionArchive.image = UIImage(systemName: "archivebox")
        let actions = UISwipeActionsConfiguration(actions: [actionEdit])
        return actions
    }
    
}

extension DictViewController: DataRequester {
    func updateData() {
        guard let dictType else {return}
        storage.getData(storage: dictType) { words in
            self.dict = words
            self.updateTitle()
            self.tableView.reloadData()
        }
    }
}

extension DictViewController {
    private func showEditForm(editingWord: WordModel) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let editVC = sb.instantiateViewController(withIdentifier: "NewWordViewController") as! NewWordViewController
        editVC.storage = self.storage
        editVC.editingWord = editingWord
        editVC.saveButtonPressed = { [weak self] editedWord in
            
            self?.storage.edit(editingWord: editingWord, editedWord: editedWord)
            self?.dismiss(animated: true)
        }
        present(editVC, animated: true)
        tableView.reloadData()
    }
}
