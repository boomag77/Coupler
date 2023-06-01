import Foundation

class CardGenerator {
    
    let countOfAnswersInCard: Int = 3
    var dictType: DictType
    var storage = StorageManager()
    var emptyCard: WordCard // Card to show if there are no card to train by the request
    
    init(dictType: DictType) {
        self.dictType = dictType
        self.emptyCard = WordCard(wordName: "No words to train in \(self.dictType.rawValue)", answers: [])
        print("Card Generator initialized")
    }
    
    //func gets not memorized words from Storage and return them in array
    private func getWordsForTrain(from dictType: DictType) -> [WordModel] {
        
        print("func getWordsToTrain started")
        var wordsToTrain: [WordModel] = []
        
        storage.getData(storage: dictType) { words in

            wordsToTrain = words

        }
        return wordsToTrain
    }
    
    func generateCard() -> WordCard {
        
        let words = getWordsForTrain(from: self.dictType)
        guard words.count > 0 else {
            return emptyCard
        }
        let randomWord = words.randomElement()!
        let answers = getAnswers(for: randomWord, from: words)
        return createCard(for: randomWord, with: answers)
        
    }
    
    private func getAnswers(for word: WordModel, from words: [WordModel]) -> [Answer] {
        
        let rightAnswer = Answer(text: word.wordDescription, isRight: true)
        var answersForWord = [rightAnswer]
        switch words.count {
        case 1:
            // probably extension AI append wrong answers or other method to generate them
            while answersForWord.count < countOfAnswersInCard {
                answersForWord.append(rightAnswer)
            }
        case 2:
            let wrongAnswer = Answer(
                text: (words.filter{$0.wordDescription != rightAnswer.text})[0].wordDescription,
                isRight: false)
            while answersForWord.count < countOfAnswersInCard {
                answersForWord.append(wrongAnswer)
            }
        default:
            while answersForWord.count < countOfAnswersInCard {
                let randomWord = words.randomElement()!
                let addedAnswers = answersForWord.map { $0.text }
                guard !addedAnswers.contains(randomWord.wordDescription) else {
                    continue
                }
                let wrongAnswer = Answer(text: randomWord.wordDescription, isRight: false)
                answersForWord.append(wrongAnswer)
            }
        }
        
        return answersForWord.shuffled()
    }
    
    /// create word Card (random word and 3 answers) and return it in array
    /// - Parameter word: Word to show in Card for training word.
    /// - Parametr answers: Answers for word (one of them is right)
    /// - Returns: training word's card as word itself and 3 answers (one of them is right)
    private func createCard(for word: WordModel, with answers: [Answer]) -> WordCard {
        let card = WordCard(wordName: word.name, answers: answers)
        return card
    }
}

