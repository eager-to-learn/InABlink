//
//  ViewController.swift
//  InABlink
//
//  Created by Corey Salzer on 4/3/17.
//  Copyright © 2017 Washington University in St. Louis. All rights reserved.
//

import UIKit
import MapKit

class LandingViewController: UIViewController {
    @IBOutlet weak var enterButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(true, forKey: "isNotFirstTime")
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.window?.rootViewController = controller
    }
    
    

}

