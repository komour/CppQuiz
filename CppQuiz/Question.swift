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

    var id: Int
    var questionBody: String
    var result: Answer
    var answer: String
    var explanation: String
    var hint: String
    var difficulty: Int
}

struct QuestionResponse:Decodable {
    var version: Int
    var cpp_standard: String
    var questions: [QuestionJson]
    
}

struct QuestionJson:Decodable {
    var id: Int
    var question: String
    var result: String
    var answer: String
    var explanation: String
    var hint: String
    var difficulty: Int
}
