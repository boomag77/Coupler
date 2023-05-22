//
//  TrainViewController.swift
//  Coupler
//
//  Created by Sergey on 5/19/23.
//

import UIKit

class TrainViewController: UIViewController {
    
    var storageType: StorageType?
    var answers: [String] = []
    
    @IBOutlet weak var wordNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let training = Training(storageType: storageType!)
        let wordForTest = training.getCard()
        // Do any additional setup after loading the view.
    }
    
    func showCurrentWord(_ word: WordCard) {
        wordNameLabel.text = word.wordName
        answers = word.answers
        tableView.reloadData()
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

extension TrainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = self.answers[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell")
        
        
        return cell!
    }
    
    
}
