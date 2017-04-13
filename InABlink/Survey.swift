//
//  Surveys.swift
//  InABlink
//
//  Created by Kateryna Kononenko on 4/8/17.
//  Copyright © 2017 Washington University in St. Louis. All rights reserved.
//

import Foundation

class Survey : NSObject, NSCoding {
    
    var questions: [Question]!
    var name:String!
    
    init(questions: [Question], name: String) {
        super.init()
        self.questions = questions
        self.name = name
    }
    
    required convenience init(coder decoder: NSCoder) {
        let questions = NSKeyedUnarchiver.unarchiveObject(with: decoder.decodeObject(forKey: "questions") as! Data) as! [Question]
        let name = decoder.decodeObject(forKey: "name") as! String
        self.init(questions: questions, name: name)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(NSKeyedArchiver.archivedData(withRootObject: questions), forKey: "questions")
        coder.encode(name, forKey: "name")
    }

}
