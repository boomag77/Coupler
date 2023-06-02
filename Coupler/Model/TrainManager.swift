
import Foundation
import UIKit

protocol TrainPresenter: UIViewController {
    var cardToShow: WordCard? {get set}
}

class TrainManager {
    
    weak var presenter: TrainPresenter?
    var dictType: DictType
    
    init(dictType: DictType) {
        self.dictType = dictType
    }
    
    func train() {
    
        let cardGenerator = CardGenerator(dictType: self.dictType)
        let cardToShow = cardGenerator.generateCard()
        guard let cardToShow else {
            self.presenter?.dismiss(animated: true)
            return
        }
        presenter?.cardToShow = cardToShow
    }
    
    func updateStat(for word: WordModel, result: Bool) {
        let wordBefore = word
        var wordAfter = word
        if result {
            wordAfter.wasRight += 1
            
        } else {
            wordAfter.wasWrong += 1
            
        }
        let storage = StorageManager()
        storage.edit(wordBeforeEdition: wordBefore, wordAfterEdition: wordAfter)
    }
}
