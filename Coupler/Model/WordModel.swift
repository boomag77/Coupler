
import Foundation

enum StorageType: String {
    case translation = "translation"
    case glossary = "glossary"
}

struct WordModel {
    
    init(name: String, wordDescription: String, storage: String, wasRight: Int64?, wasWrong: Int64?) {
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
    }
    
    var name: String
    var wordDescription: String
    var storage: String
    var wasRight: Int64
    var wasWrong: Int64
    var trainedCount: Int64 {
        return wasRight + wasWrong
    }
    var complexity: Float {
        guard trainedCount > 0 else { return 100 }
        return (Float(wasWrong) / Float(trainedCount)) * 100
    }
    var memorized: Bool {
        guard trainedCount > 19 && complexity < 5 else { return false }
        return true
    }
}
