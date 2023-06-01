
import Foundation

enum DictType: String {
    case translation = "translation"
    case glossary = "glossary"
}


struct WordModel {
    
    init(name: String,
         wordDescription: String,
         storage: String,
         wasRight: Int64? = nil,
         wasWrong: Int64? = nil,
         dateOfAdd: String? = nil,
         lastTrained: String? = nil
    ) {
        self.name = name
        self.wordDescription = wordDescription
        self.storage = storage
        if let wasRight {
            self.wasRight = wasRight
        } else {
            self.wasRight = 0
        }
        if let wasWrong {
            self.wasWrong = wasWrong
        } else {
            self.wasWrong = 0
        }
        if let date = dateOfAdd {
            self.dateOfAdd = date
        } else {
            let dateFormat = DateFormatter()
            dateFormat.locale = Locale.current
            dateFormat.dateStyle = .medium
            dateFormat.timeStyle = .none
            let date = Date()
            self.dateOfAdd = dateFormat.string(from: date)
        }
    }
    
    var name: String
    var wordDescription: String
    var storage: String
    var dateOfAdd: String
    var wasRight: Int64
    var wasWrong: Int64
    var trainedCount: Int64 {
        return wasRight + wasWrong
    }
    var complexity: Float {
        guard trainedCount != 0 else { return 100 }
        return (Float(wasWrong) / Float(trainedCount)) * 100
    }
    var memorized: Bool {
        guard trainedCount > 19 && complexity < 5 else { return false }
        return true
    }
    
    private func saveChanges() {
        let storage = StorageManager()
        
    }
}


