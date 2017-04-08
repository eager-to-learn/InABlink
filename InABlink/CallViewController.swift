//
//  CallViewController.swift
//  InABlink
//
//  Created by Rachel on 4/8/17.
//  Copyright © 2017 Washington University in St. Louis. All rights reserved.
//

import UIKit

struct CallerInfo {
    var name: String
    var number: String
}

class CallViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //var callers: [CallerInfo] = []
    //var callers2: [String:String] = [:]
    var names: [String] = []
    var numbers: [String] = []
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let results = UserDefaults.standard.value(forKey: "name") {
            names = results as! [String]
        }
        if let results = UserDefaults.standard.value(forKey: "number") {
            numbers = results as! [String]
        }
        
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = names[indexPath.row]
        cell.detailTextLabel?.text = numbers[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let results = UserDefaults.standard.value(forKey: "name") {
            names = results as! [String]
        }
        return names.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let results = UserDefaults.standard.value(forKey: "number") {
            numbers = results as! [String]
        }
        callNumber(phoneNumber: numbers[indexPath.row])
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if let results = UserDefaults.standard.value(forKey: "name") {
                names = results as! [String]
            }
            if let results = UserDefaults.standard.value(forKey: "numbers") {
                numbers = results as! [String]
            }
            names.remove(at: indexPath.row)
            numbers.remove(at: indexPath.row)
            UserDefaults.standard.setValue(names, forKey: "name")
            UserDefaults.standard.setValue(numbers, forKey: "number")
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func addCallerPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addCaller", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let results = UserDefaults.standard.value(forKey: "name") {
            names = results as! [String]
            for result in names {
                print(result)
            }
        }
        if let results = UserDefaults.standard.value(forKey: "number") {
            numbers = results as! [String]
            for result in numbers {
                print(result)
            }
        }
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if let results = UserDefaults.standard.value(forKey: "name") {
            names = results as! [String]
        }
        else {
            UserDefaults.standard.setValue(names, forKey: "name")
        }
        
        
        if let results = UserDefaults.standard.value(forKey: "number") {
            numbers = results as! [String]
        }
        else {
            UserDefaults.standard.setValue(numbers, forKey: "number")
        }
        
        self.title = "No Judgement Call"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
