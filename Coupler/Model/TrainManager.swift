
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
        guard let cardToShow else {
            self.presenter?.dismiss(animated: true)
            return
        }
        presenter?.cardToShow = cardToShow
    }
    
    func checkAnswer(answer: String) {
        
    }
}
