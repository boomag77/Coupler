import Foundation
//import UIKit

class CardGenerator {
    
    
    var dictType: StorageType
    var wordsToTrain: [WordModel]?
    var storage = StorageManager()
    
    init(dictType: StorageType) {
        self.dictType = dictType
        print("Card Generator initialized")
    }
        
    //private var wordsForTrain: [WordModel] = getWordsForTrain(from: storageType).shuffled()
    
    //func gets not memorized words from Storage and return them in array
    func getWordsForTrain(from dictType: StorageType) -> [WordModel] {
        print("func getWordsToTrain started")
        var wordsToTrain: [WordModel] = []
        print(storage)
        storage.getData(storage: dictType) { words in

            print("closure \(words)")
            wordsToTrain = words
            print("!!! \(wordsToTrain)")

        }
        return wordsToTrain
    }
    
    func generateCard() -> WordCard {
        
        print("func generateCard started")
        let words = getWordsForTrain(from: .translation)
        print(words)
        let randomWord = words.randomElement()
        print(randomWord!)
        return createCard(for: randomWord!)
        
    }
    
    /// create word Card (random word and 3 answers) and return it in array
    /// - Parameter word: Word to show in Card for training word.
    /// - Returns: training word's card as word itself and 3 answers (one of them is right)
    private func createCard(for word: WordModel) -> WordCard {
        var answersForCard: [String] = [word.wordDescription]
        //let cloudOfWrongAnswers = getAllAnswers(for: word.storage)
        let cloudOfWrongAnswers = ["alt answer #2", "alt answer #3"]
        answersForCard.append(cloudOfWrongAnswers[0])
        answersForCard.append(cloudOfWrongAnswers[1])
//        while answersForCard.count < 3 {
//            if let answer = cloudOfWrongAnswers.randomElement() {
//                answersForCard.append(answer)
//            }
//        }
        let card = WordCard(wordName: word.name, answers: answersForCard)
        return card
    }
    
    private func getAllAnswers(for storage: String) -> [String] {
        //TODO
        return []
    }
    
    
    
    private func updateWordStats(for word: WordModel) {
        // TODO
        // here word saves to CoreData Storage with new stats (wasRight, wasWrong)
    }
    
//    private func getRandomWord() -> WordModel? {
//
//        return self.wordsForTrain.randomElement()
//    }
}

