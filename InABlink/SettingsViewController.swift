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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
