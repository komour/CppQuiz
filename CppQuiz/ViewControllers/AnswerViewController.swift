//
//  AnswerViewController.swift
//  CppQuiz
//
//  Created by Always Strive And Prosper on 04.01.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

func questionAnswerToString(_ answer: Question.Answer) -> String {
    switch answer {
    case .output(_):
        return "The program is guaranteed to output: "
    case .compilationError:
        return "Compilation error."
    case .undefined:
        return "Undefined behavior."
    default:
        return "Unspecified / Implementation defined."
    }
}

@available(iOS 13.0, *)
class AnswerViewController: UIViewController {
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var explanationTextView: UITextView!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTextView.isEditable = false
        questionTextView.isScrollEnabled = true
        
        explanationTextView.isEditable = false
        explanationTextView.isScrollEnabled = true

        let curQuestion = ViewController.curQuestion!
        
        navigationBar.title = "Explanation"
        questionTextView.text = curQuestion.questionBody
        if curQuestion.result == .output(curQuestion.answer) {
            answerLabel.text = questionAnswerToString(curQuestion.result) + curQuestion.answer
        } else {
        answerLabel.text = questionAnswerToString(curQuestion.result)
        }
        explanationTextView.text = curQuestion.explanation
        
        
    }
    @IBAction func nextQuestionButton() {
        navigationController?.popViewController(animated: true)
    }
    
}
