//
//  MessagesViewController.swift
//  InABlink
//
//  Created by Rachel on 4/10/17.
//  Copyright © 2017 Washington University in St. Louis. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageBody: UITextView!
    
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
    
    func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        
        tableView.reloadData()
        
        if let results = UserDefaults.standard.value(forKey: "image") {
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(data:results as! Data)
        }
        
        if let results = UserDefaults.standard.value(forKeyPath: "message") {
            messageBody.text = String(describing: results)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        messageBody.isEditable = false
        
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
