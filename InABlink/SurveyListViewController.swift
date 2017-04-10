//
//  SurveyViewController.swift
//  InABlink
//
//  Created by Kateryna Kononenko on 4/8/17.
//  Copyright © 2017 Washington University in St. Louis. All rights reserved.
//

import Foundation
import UIKit


class SurveyListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var surveys = [Survey]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let survey1 = Survey()
        survey1.questions.append(Question(content: "I am experiencing bouts of depression today."))
        survey1.questions.append(Question(content: "I am feeling the need to drink/use drugs."))
        survey1.questions.append(Question(content: "I am feeling angry at the world in general."))
        survey1.questions.append(Question(content: "I am doing things to stay sober today."))
        survey1.questions.append(Question(content: "I have thought about drinking/using drugs today."))
        survey1.questions.append(Question(content: "I'm feeling sorry for myself today."))
        survey1.questions.append(Question(content: "I am thinking clear today."))
        survey1.questions.append(Question(content: "I have a positive outlook on life today."))
        survey1.name = "Survey 1"
        
        surveys.append(survey1)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveys.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyListCell",for:indexPath as IndexPath) as! SurveyListCell
        
        cell.surveyName.text = surveys[indexPath.row].name
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToSurveyView", sender: surveys[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? SurveyViewController, let survey = sender as? Survey
        {
            viewController.survey = survey
        }
    }
    
}
