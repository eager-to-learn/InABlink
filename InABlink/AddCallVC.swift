//
//  AddCallVC.swift
//  InABlink
//
//  Created by Rachel on 4/8/17.
//  Copyright © 2017 Washington University in St. Louis. All rights reserved.
//

import UIKit

class AddCallVC: UIViewController {
    
    var tempName: [String] = []
    var tempNumber: [String] = []
    
    @IBOutlet weak var enteredName: UITextField!
    @IBOutlet weak var enteredNumber: UITextField!
    
    @IBOutlet weak var addButton: UIButton!

    @IBOutlet weak var successMessage: UILabel!
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if ((enteredName.text!.isEmpty) || enteredNumber.text!.isEmpty) {
            
            if (enteredName.text!.isEmpty) {
                enteredName.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
            if (enteredNumber.text!.isEmpty) {
                enteredNumber.attributedPlaceholder = NSAttributedString(string: "number", attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
        }
        else {
            if let results = UserDefaults.standard.value(forKey: "name") {
                tempName = results as! [String]
                tempName.append(enteredName.text!)
                UserDefaults.standard.setValue(tempName, forKey: "name")
            }
            if let results = UserDefaults.standard.value(forKey: "number") {
                tempNumber = results as! [String]
                tempNumber.append(enteredNumber.text!)
                UserDefaults.standard.setValue(tempNumber, forKey: "number")
            }
            successMessage.isHidden = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        successMessage.isHidden = true

        addButton.layer.cornerRadius = 5
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
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
