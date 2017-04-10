//
//  File.swift
//  InABlink
//
//  Created by Kateryna Kononenko on 4/8/17.
//  Copyright © 2017 Washington University in St. Louis. All rights reserved.
//

import Foundation
import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var sliderValue: UILabel!

    @IBAction func valueChanged(_ sender: Any) {
        sliderValue.text = String(Int(floor(ratingSlider.value)))
    }
}
