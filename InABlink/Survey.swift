//
//  Surveys.swift
//  InABlink
//
//  Created by Kateryna Kononenko on 4/8/17.
//  Copyright © 2017 Washington University in St. Louis. All rights reserved.
//

import Foundation


class Survey {
    
    var questions = [Question]()
    
    var name:String!
    
    init(questionContents: [String]) {
        var questions:[Question] = []
        for questionContent in questionContents {
            questions.append(Question(content: questionContent))
        }
        self.questions = questions
    }
    
    func getQuestionContents() -> [String] {
        var questionContents:[String] = []
        for question in questions {
            questionContents.append(question.content)
        }
        return questionContents
    }

}
