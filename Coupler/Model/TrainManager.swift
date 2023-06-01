
import Foundation
import UIKit

protocol TrainPresenter: UIViewController {
    var cardToShow: WordCard? {get set}
}

class TrainManager {
    
    var presenter: TrainPresenter?
    var dictType: DictType
    
    init(dictType: DictType) {
        self.dictType = dictType
    }
    
    func train() {
        
        let cardGenerator = CardGenerator(dictType: self.dictType)
        let cardToShow = cardGenerator.generateCard()
        presenter?.cardToShow = cardToShow
    }
    
    func checkAnswer(answer: String) {
        
    }
}
