
import Foundation
import UIKit

protocol TrainPresenter: UIViewController {
    //var dictType: StorageType? {get set}
    //var cardToShow: WordCard? {get set}
    func show(card: WordCard)
}

class TrainManager {
    
    var presenter: TrainPresenter?
    
    var dictType: StorageType
    
    init(dictType: StorageType) {
        self.dictType = dictType
    }
    
    func train() {
        
        let cardGenerator = CardGenerator(dictType: self.dictType)
        let cardToShow = cardGenerator.generateCard()
        
        
        self.presenter?.show(card: cardToShow)
    }
}