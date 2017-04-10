//
//  SurveyViewController.swift
//  InABlink
//
//  Created by Kateryna Kononenko on 4/8/17.
//  Copyright © 2017 Washington University in St. Louis. All rights reserved.
//

import Foundation
import UIKit


class SurveyViewController: UIViewController, UITableViewDataSource {

    var survey: Survey!
    
    let questioncount = 8

    @IBOutlet weak var surveyTitle: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
      surveyTitle.text = "Rate each of the statements from 0 to 10."
        tableView.estimatedRowHeight = 110
        tableView.allowsSelection = false
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return survey.questions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == survey.questions.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubmitTableViewCell", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell") as! QuestionTableViewCell
        
        cell.question.text = survey.questions[indexPath.row].content
        return cell
    }
    
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        //show popup
        let alert = UIAlertController(title: "Thanks", message: "Your answers have been successfully sent", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
        _ = self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    

}
