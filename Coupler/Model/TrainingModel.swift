import Foundation

struct Training {
    
    var storageType: StorageType
        
    private var wordsForTrain: [WordModel] {
        getWordsForTrain(from: self.storageType)
    }
    
    //func gets not memorized words from Storage and return them in array
    private func getWordsForTrain(from storageType: StorageType) -> [WordModel] {
        //TODO
        return []
    }
    
    func checkAnswer(for wordName: String, selectedAnswer: String) {
        let word = wordsForTrain.filter { $0.name == wordName }.first
        
        if var word {
            if selectedAnswer == word.wordDescription {
                word.wasRight += 1
            } else {
                word.wasWrong += 1
            }
            self.updateWordStats(for: word)
        }
    }
    
    func getCard(for word: WordModel? = nil) -> WordCard? {
        
        guard let word else {
            if wordsForTrain.isEmpty {
                return nil
            }
            let randomWord = self.wordsForTrain.randomElement()
            return createCard(for: randomWord!)
        }
        return createCard(for: word)
    }
    
    //func create word Card (random word and 3 answers) and return it in array
    private func createCard(for word: WordModel) -> WordCard {
        var card = WordCard(word: word.name, answers: generateAnswers(for: word))
        return card
    }
    
    private func generateAnswers(for word: WordModel) -> [String] {
        var answers: [String] = [word.wordDescription]
        while answers.count < 3 {
            if let answer = wordsForTrain.randomElement()?.wordDescription {
                answers.append(answer)
            }
        }
        return answers
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
