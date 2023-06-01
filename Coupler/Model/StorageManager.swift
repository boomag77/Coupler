
import Foundation
import UIKit
import CoreData


/// an object with statistics data of CoreData storage
struct StorageStat {
    var translationCount: Int
    var glossaryCount: Int
}

/// Any Object wich conform this protocol is requests Data from Storage manager
protocol DataRequester: AnyObject {
    func updateData()
}

/// perform all operations with CoreData storage
class StorageManager: DataStorageManager {
    
    init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.persistentContainer.viewContext
    }
    
    weak var dataRequester: DataRequester? {
        // probably to DELETE the didSet because of doublicating performing updateData
        didSet {
            dataRequester?.updateData()
        }
    }
    let appDelegate: AppDelegate
    let managedContext: NSManagedObjectContext
    
    /// convert NSManagedObject to WordModel
    /// - Parameter entities: an array of NSManagedObject entities
    /// - Returns: an array of WordModel objects
    private func transformToWordModel(entities: [NSManagedObject]) -> [WordModel] {
        let words = entities.map {
            WordModel(name: $0.value(forKey: "name") as? String ?? "",
                      wordDescription: $0.value(forKey: "wordDescription") as? String ?? "",
                      storage: $0.value(forKey: "storage") as? String ?? "",
                      wasRight: $0.value(forKey: "wasRight") as? Int64,
                      wasWrong: $0.value(forKey: "wasWrong") as? Int64,
                      dateOfAdd: $0.value(forKey: "dateOfAdd") as? String
                    )
            
            
        }
        return words
    }
    
    /// perform the closure with CoreData stotage statistics
    /// - Parameter completion: closure with an object of StorageStat as a parameter
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
    
    
    /// perform the closure with an array of words from CoreData Storage by predicted dictionary type
    /// - Parameters:
    ///   - dict: dictionary type: translaition or glossary
    ///   - completion: closure with words array
    func getData(for dict: DictType, completion: @escaping ([WordModel]) -> Void) {
        
        var predicate: NSPredicate {
            return dict == .translation ?
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
    
    
    /// save new Word to CoreData storage
    /// - Parameter word: new Word as WordModel
    func saveNew(word: WordModel) {
        
        let entity = NSEntityDescription.entity(forEntityName: "WordEntity", in: managedContext)!
        let newWord = NSManagedObject(entity: entity, insertInto: managedContext)
        
        let mirrorNewWord = Mirror(reflecting: word)
        
        for (label,value) in mirrorNewWord.children {
            if let label = label {
                newWord.setValue(value, forKey: label)
            }
        }
        do {
            try self.managedContext.save()
        } catch let error as NSError {
            print("Could not save.\(error), \(error.userInfo)")
        }
        
        print("Word \(word.name) added to \(word.storage)")
        self.dataRequester?.updateData()
        
    }
    
    
    
    /// perform Word edition in CoreData storage
    /// - Parameters:
    ///   - wordBeforeEdition: old (existed) edition of the word
    ///   - wordAfterEdition: new edition of the word
    func edit(wordBeforeEdition: WordModel, wordAfterEdition: WordModel) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WordEntity")
        let predicate = NSPredicate(format: "name == %@", wordBeforeEdition.name)
        fetchRequest.predicate = predicate
        
        do {
            let result = try self.managedContext.fetch(fetchRequest)
            
            if let objectToEdit = result.first {
                
                guard objectToEdit.value(forKey: "name") as? String == wordAfterEdition.name else {
                    self.delete(wordBeforeEdition)
                    self.saveNew(word: wordAfterEdition)
                    return
                }
                
                let mirrorAfter = Mirror(reflecting: wordAfterEdition)
                
                for (label,value) in mirrorAfter.children {
                    if let label = label {
                        objectToEdit.setValue(value, forKey: label)
                    }
                }
                try managedContext.save()
            }
            
        } catch let error as NSError {
            print("Could not edit. \(error), \(error.localizedDescription)")
        }
        
        dataRequester?.updateData()
        
    }
    
    /// perform erasing a word from CoreData storage if this word is existing in CoreData storage
    /// - Parameter word: a WordModel object
    func delete(_ word: WordModel) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WordEntity")
        let predicate = NSPredicate(format: "name == %@", word.name)
        fetchRequest.predicate = predicate
        do {
            let object = try self.managedContext.fetch(fetchRequest)
            if !object.isEmpty {
                self.managedContext.delete(object.first!)
                try self.managedContext.save()
            }
            
        } catch let error as NSError {
            print("Could not fetch or delete object. \(error), \(error.localizedDescription)")
        }
        self.dataRequester?.updateData()
        
    }
}
