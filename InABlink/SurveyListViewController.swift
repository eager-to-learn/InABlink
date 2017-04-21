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

    var surveys: [Survey] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let surveyNames = UserDefaults.standard.stringArray(forKey: "surveyNames")!
        
        for surveyName in surveyNames {
            let data = UserDefaults.standard.data(forKey: surveyName)!
            surveys.append(NSKeyedUnarchiver.unarchiveObject(with: data) as! Survey)
        }
        
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let isFirstTime = UserDefaults.standard.value(forKey: "surveyFirstTime") as? Bool {
            if (isFirstTime == false) {
                print("not first time")
            }
        }
        else {
            print("first time")
            let alert = UIAlertController(title: "Welcome to the Survey Page!", message: "Use this tab to fill out surveys and send feedback to your counselor. You will receive notifications that will prompt you to complete each survey once a day.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: { (_) in
                _ = self.navigationController?.popToRootViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
        UserDefaults.standard.set(false, forKey: "surveyFirstTime")
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
