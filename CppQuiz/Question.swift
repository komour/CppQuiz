//
//  Question.swift
//  CppQuiz
//
//  Created by Always Strive n Prosper on 23/10/2019.
//  Copyright © 2019 komarov. All rights reserved.
//

import Foundation

enum pickOption {
    case OK
    case CE
    case UID
    case UB
    case udefined
}

struct Question
{
    var correctAnswer : pickOption = pickOption.udefined
    var questionBody : String = ""
    
    
    // Было бы неплохо эту часть экрана таки сделать :)
}
