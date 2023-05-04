
import Foundation
import UIKit
import CoreData


struct StorageStat {
    var translationCount: Int
    var glossaryCount: Int
}

protocol DataRequester: UIViewController {
    func updateData()
}

class StorageManager: DataStorageManager {
    
    init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.persistentContainer.viewContext
    }
    
    weak var dataRequester: DataRequester?
    let appDelegate: AppDelegate
    let managedContext: NSManagedObjectContext
    
    private func transformToWordModel(entities: [NSManagedObject]) -> [WordModel] {
        let words = entities.map {
            WordModel(name: $0.value(forKey: "name") as? String ?? "",
                      wordDescription: $0.value(forKey: "wordDescription") as? String ?? "",
                      storage: $0.value(forKey: "storage") as? String ?? "",
                      wasRight: $0.value(forKey: "wasRight") as? Int64,
                      wasWrong: $0.value(forKey: "wasWrong") as? Int64
            )
        }
        return words
    }
    
    func getStats(completion: @escaping (StorageStat) -> Void) {
        var stat = StorageStat(translationCount: 0, glossaryCount: 0)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WordEntity")
        DispatchQueue.main.async {
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
    }
    
    
    func getData(storage: StorageType, completion: @escaping ([WordModel]) -> Void) {
        
        var predicate: NSPredicate {
            return storage == .translation ?
            NSPredicate(format: "storage == %@", "translation"):
            NSPredicate(format: "storage == %@", "glossary")
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WordEntity")
        fetchRequest.predicate = predicate
        DispatchQueue.main.async {
            do {
                
                let entities = try self.managedContext.fetch(fetchRequest)
                let words = self.transformToWordModel(entities: entities)
                completion(words)
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                completion([])
            }
        }
    }
    
    func isExist(word: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WordEntity")
        let predicate = NSPredicate(format: "name == %@", word)
        fetchRequest.predicate = predicate
        
        do {
            let result = try self.managedContext.fetch(fetchRequest)
            return !result.isEmpty
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func addNew(word: WordModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let entity = NSEntityDescription.entity(forEntityName: "WordEntity", in: managedContext)!
        let newWord = NSManagedObject(entity: entity, insertInto: managedContext)
        newWord.setValue(word.name, forKeyPath: "name")
        newWord.setValue(word.wordDescription, forKeyPath: "wordDescription")
        newWord.setValue(word.storage, forKeyPath: "storage")
        
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
