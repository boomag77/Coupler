//
//  WordViewController.swift
//  Coupler
//
//  Created by Sergey on 5/9/23.
//

import UIKit

class WordViewController: UIViewController {
    
    var word: WordModel?

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var dateAddedLabel: UILabel!
    @IBOutlet weak var storageLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var complexityLabel: UILabel!
    @IBOutlet weak var tranedCountLabel: UILabel!
    @IBOutlet weak var wasRightLabel: UILabel!
    @IBOutlet weak var wasWrongLabel: UILabel!
    
    @IBOutlet weak var meaningLabelAsButton: UIButton!
    
    @IBOutlet weak var statisticsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateLabels(word: self.word)
        //preferredContentSize = CGSize(width: 300, height: 200)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cancelbuttonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func updateLabels(word: WordModel?) {
        guard let word else { return }
        wordLabel.text = word.name
        storageLabel.text = "\(word.storage) word".capitalized
        meaningLabel.text = word.wordDescription
        meaningLabel.layer.backgroundColor = UIColor.systemGray6.cgColor
        meaningLabel.layer.borderWidth = 1
        meaningLabel.layer.borderColor = UIColor.systemGray6.cgColor
        meaningLabel.layer.cornerRadius = 10.0
        meaningLabel.layer.shadowColor = UIColor.systemGray3.cgColor
        meaningLabel.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        meaningLabel.layer.shadowOpacity = 1.0
        meaningLabel.layer.shadowRadius = 1.0
        complexityLabel.text = "\(word.complexity)%"
        tranedCountLabel.text = "Trained \(word.trainedCount) time(s)"
        wasRightLabel.text = "\(word.wasRight) time(s) was right"
        wasWrongLabel.text = "\(word.wasWrong) time(s) was wrong"
        if let date = word.dateOfAdd {
            self.dateAddedLabel.text = date
        }
        
        statisticsStackView.layer.backgroundColor = UIColor.systemGray6.cgColor
        statisticsStackView.layer.borderWidth = 1
        statisticsStackView.layer.borderColor = UIColor.systemGray6.cgColor
        statisticsStackView.layer.cornerRadius = 10.0
        statisticsStackView.layer.shadowColor = UIColor.systemGray3.cgColor
        statisticsStackView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        statisticsStackView.layer.shadowOpacity = 1.0
        statisticsStackView.layer.shadowRadius = 1.0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
