
import Foundation
import UIKit
import CoreData


struct StorageStat {
    var translationCount: Int
    var glossaryCount: Int
}

protocol DataRequester: AnyObject {
    func updateData()
}

class StorageManager: DataStorageManager {
    
    init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.persistentContainer.viewContext
    }
    
    weak var dataRequester: DataRequester? {
        didSet {
            dataRequester?.updateData()
        }
    }
    let appDelegate: AppDelegate
    let managedContext: NSManagedObjectContext
    
    private func transformToWordModel(entities: [NSManagedObject]) -> [WordModel] {
        let words = entities.map {
            WordModel(name: $0.value(forKey: "name") as? String ?? "",
                      wordDescription: $0.value(forKey: "wordDescription") as? String ?? "",
                      storage: $0.value(forKey: "storage") as? String ?? "",
                      wasRight: $0.value(forKey: "wasRight") as? Int64,
                      wasWrong: $0.value(forKey: "wasWrong") as? Int64,
                      dateOfAdd: $0.value(forKey: "addedDate") as? String
                    )
            
            
        }
        return words
    }
    
    func getStats(completion: @escaping (StorageStat) -> Void) {
        var stat = StorageStat(translationCount: 0, glossaryCount: 0)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WordEntity")
        
        do {
            let predicate1 = NSPredicate(format: "storage == %@", "translation")
            fetchRequest.predicate = predicate1
            stat.translationCount = try self.managedContext.count(for: fetchRequest)
            let predicate2 = NSPredicate(format: "storage == %@", "glossary")
            fetchRequest.predicate = predicate2
            stat.glossaryCount = try self.managedContext.count(for: fetchRequest)
            completion(stat)
        } catch let error as NSError {
            print("Could not fetch for count. \(error), \(error.userInfo)")
            stat.glossaryCount = 0
            stat.translationCount = 0
            completion(stat)
        }
        
    }
    
    
    func getData(storage: StorageType, completion: @escaping ([WordModel]) -> Void) {
        
        var predicate: NSPredicate {
            return storage == .translation ?
            NSPredicate(format: "storage == %@", "translation"):
            NSPredicate(format: "storage == %@", "glossary")
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WordEntity")
        fetchRequest.predicate = predicate
        
        do {
            
            let entities = try self.managedContext.fetch(fetchRequest)
            let words = self.transformToWordModel(entities: entities)
            print("from completion - \(words)")
            completion(words)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completion([])
        }
        
    }
    
    private func isExist(wordName: String, completion: @escaping (WordModel?) -> Void) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WordEntity")
        let predicate = NSPredicate(format: "name == %@", wordName)
        fetchRequest.predicate = predicate
        
        do {
            let result = try self.managedContext.fetch(fetchRequest)
            guard result.isEmpty else {
                let existingWord = transformToWordModel(entities: (result)).first!
                completion(existingWord)
                return
            }
            completion(nil)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    func addNew(word: WordModel) {
        
        let entity = NSEntityDescription.entity(forEntityName: "WordEntity", in: managedContext)!
        let newWord = NSManagedObject(entity: entity, insertInto: managedContext)
        newWord.setValue(word.name, forKeyPath: "name")
        newWord.setValue(word.wordDescription, forKeyPath: "wordDescription")
        newWord.setValue(word.storage, forKeyPath: "storage")
        newWord.setValue(word.dateOfAdd, forKeyPath: "addedDate")
        newWord.setValue(word.wasRight, forKey: "wasRight")
        newWord.setValue(word.wasWrong, forKey: "wasWrong")
        
        
        switch word.storage {
            case "translation":
                do {
                    try self.managedContext.save()
                } catch let error as NSError {
                    print("Could not save.\(error), \(error.userInfo)")
                }
            default:
                do {
                    try self.managedContext.save()
                } catch let error as NSError {
                    print("Could not save.\(error), \(error.userInfo)")
                }
        }
        print("Word \(word.name) added to \(word.storage)")
        self.dataRequester?.updateData()
        
    }
    
    func edit(editingWord: WordModel, editedWord: WordModel) {
        var namesIsTheSame: Bool = false
        
        isExist(wordName: editedWord.name) { existingWord in
            if let _ = existingWord {
                namesIsTheSame = true
            }
        }
        
        if namesIsTheSame {
            guard editingWord.wordDescription == editedWord.wordDescription else {
                // actions if descriptions are different
                var wordToSave = editingWord
                let newDescription = editedWord.wordDescription
                wordToSave.wordDescription = newDescription
                print(wordToSave.wordDescription)
                if editingWord.storage == editedWord.storage {
                    // actions if storageies are the same
                    self.delete(editingWord)
                    self.addNew(word: wordToSave)
                    
                } else {
                    var wordToSave = editingWord
                    wordToSave.storage = editedWord.storage
                    self.delete(editingWord)
                    self.addNew(word: wordToSave)
                    
                    // actions if only storagies are different
                    
                }
                return
            }
            if editingWord.storage == editedWord.storage {
                guard editedWord.wasRight == editingWord.wasRight,
                      editedWord.wasWrong == editingWord.wasWrong else {
                    let wordToSave = editedWord
                    self.delete(editingWord)
                    self.addNew(word: wordToSave)
                    self.dataRequester?.updateData()
                    return
                }
                self.dataRequester?.updateData()
                
            } else {
                var wordToSave = editingWord
                wordToSave.storage = editedWord.storage
                self.delete(editingWord)
                self.addNew(word: wordToSave)
            }
        } else {
            self.delete(editingWord)
            self.addNew(word: editedWord)
        }
    }
    
    func delete(_ word: WordModel) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WordEntity")
        let predicate = NSPredicate(format: "name == %@", word.name)
        fetchRequest.predicate = predicate
        do {
            let object = try self.managedContext.fetch(fetchRequest)
            if !object.isEmpty {
                self.managedContext.delete(object.first!)
            }
            try self.managedContext.save()
        } catch let error as NSError {
            print("Could not fetch or delete object. \(error), \(error.userInfo)")
        }
        self.dataRequester?.updateData()
        
    }
}
