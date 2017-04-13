//
//  Questions.swift
//  InABlink
//
//  Created by Kateryna Kononenko on 4/8/17.
//  Copyright © 2017 Washington University in St. Louis. All rights reserved.
//

import Foundation

class Question : NSObject, NSCoding {
    var content: String!
    var answer: Int?
    
    init(content: String) {
        super.init()
        self.content = content
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init(content: decoder.decodeObject(forKey: "content") as! String)
        self.answer = decoder.decodeObject(forKey: "answer") as? Int
        
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(content, forKey: "content")
        coder.encode(answer, forKey: "answer")
    }
    
}
