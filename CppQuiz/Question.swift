//
//  Question.swift
//  CppQuiz
//
//  Created by Always Strive n Prosper on 23/10/2019.
//  Copyright © 2019 komarov. All rights reserved.
//

import Foundation

struct Question {
    enum Answer: Equatable {
        case output(String)
        case compilationError
        case unspecified
        case undefined
    }

    var correctAnswer: Answer
    var questionBody: String
    var questionNumber: Int
    
    
}
