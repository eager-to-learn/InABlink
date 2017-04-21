//
//  SettingsViewController.swift
//  InABlink
//
//  Created by Rachel on 4/10/17.
//  Copyright © 2017 Washington University in St. Louis. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var messageBody: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBAction func addPhoto(_ sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    @IBAction func takePhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        }
        else {
            let alertVC = UIAlertController(
                title: "No Camera",
                message: "Sorry, this device has no camera",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.default,
                handler: nil)
            alertVC.addAction(okAction)
            present(
                alertVC,
                animated: true,
                completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage
        
        let imageData = UIImagePNGRepresentation(chosenImage)
        UserDefaults.standard.set(imageData, forKey: "image")
        dismiss(animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setTimeButton(_ sender: UIButton) {
        UserDefaults.standard.set(timePicker.date, forKey: "surveyTime")
        let alert = UIAlertController(title: "Success!", message: "Survey time successfully set.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            _ = self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timePicker.datePickerMode = UIDatePickerMode.time
        timePicker.timeZone = NSTimeZone.local
        
        picker.delegate = self
        messageBody.delegate = self
        
        if let results = UserDefaults.standard.value(forKeyPath: "image") {
            imageView.image = UIImage(data:results as! Data)
        }
        
        if let results = UserDefaults.standard.value(forKeyPath: "message") {
            messageBody.text = String(describing: results)
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        messageBody.layer.borderWidth = CGFloat(1)
        messageBody.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let isFirstTime = UserDefaults.standard.value(forKey: "settingsFirstTime") as? Bool {
            if (isFirstTime == false) {
                print("not first time")
            }
        }
        else {
            print("first time")
            let alert = UIAlertController(title: "Welcome to the Settings Page!", message: "Use this tab to select a motivational photo from your photo album or by taking one with the camera and  fill out the message box. These will appear when you enter a delegated zone. You can also set the time of day you would prefer to receive notifications reminding you to take a survey.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: { (_) in
                _ = self.navigationController?.popToRootViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
        UserDefaults.standard.set(false, forKey: "settingsFirstTime")
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        
        UserDefaults.standard.set(messageBody.text, forKey: "message")
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
