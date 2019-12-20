//
//  ViewController.swift
//  CppQuiz
//
//  Created by Always Strive n Prosper on 20/10/2019.
//  Copyright © 2019 komarov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    

    var questionList = [Question]()
    var favoriteQuestionList = [Question]()
    
    func initializeQuestionList(forList questionList: [Question]) {
        let listSize = Int.random(in: 3...9)
        for _ in 0 ... listSize {
            let intForPickOpt = Int.random(in: 1...4)
            var curPickOpt : pickOption
            switch intForPickOpt {
            case 1:
                curPickOpt = pickOption.OK
            case 2:
                curPickOpt = pickOption.CE
            case 3:
                curPickOpt = pickOption.UB
            default:
                curPickOpt = pickOption.UID
            }
            let stringLength = Int.random(in: 42...1000)
            let newQuestion = Question(correctAnswer: curPickOpt, questionBody: randomString(length: stringLength))
            
            self.questionList.append(newQuestion)
        }
    }
    
    
    
    let pickOptions = ["The program is guaranteed to output.", "Compilation error.", "Unspecified / Implementation defined.", "Undefined behavior."]
    
//    let pickOptionsCount = 4
//
    func pickOptionToString(option: pickOption) -> String {
        switch option {
        case .OK:
            return "The program is guaranteed to output."
        case .CE:
            return "Compilation error."
        case .UID:
            return "Unspecified / Implementation defined."
        default:
            return "Undefined behavior."
        }
    }
    
    
    
    var someText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    var answerView : UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeQuestionList(forList: questionList)
        
        answerView = verticalStackView.arrangedSubviews[1]
        answerView!.isHidden = true
        setupTextFields()
        let pickerView = UIPickerView()
        pickerView.delegate = self
//        questionTextView.delegate = self
        textFieldPicker.inputView = pickerView
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil) // А отписаться?)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                //TODO: Если экран сверстан на автолейауте, то и изменения нужно делать в констрэинтах, иначе следующий-же цикл пересчета верстки сбросит отступ обратно в ноль
            }
        }
    }
    
    

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldPicker.text = pickOptions[row]
        if row == 0 {
            answerView!.isHidden = false
        } else {
            answerView!.isHidden = true
        }
    }

    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var textFieldAnswer: UITextField!
    @IBOutlet weak var textFieldPicker: UITextField!
    

    
    func textViewShouldBeginEditing(textField: UITextView) -> Bool {
        if textField == questionTextView {
            return false; //do not show keyboard nor cursor
        }
        return true
    }
    
    func displayQuestion(forQuestion question: Question) {
        questionTextView.text = question.questionBody
        curQuestion = question
    }
    
    @IBAction func skipButton() {
        let randomQuestion = questionList.randomElement()!
        displayQuestion(forQuestion: randomQuestion)
//        questionTextView.text = someText
//        print(questionList.count)
    }
    
    @IBOutlet weak var verticalStackView: UIStackView!
    
    
    @IBAction func answerButton() {
        let curAnswer = textFieldPicker.text
        if (curAnswer == nil) {
            
        } else {
            if curAnswer == pickOptionToString(option: curQuestion.correctAnswer) {
                print("Correct Answer!")
                displayQuestion(forQuestion: questionList.randomElement()!)
            } else {
                print("Wrong Answer!")
            }
        }
    }
    
    @IBAction func giveUpButton() {
        skipButton()
    }
    
    
    var curQuestion : Question = Question()
    
    func setupTextFields() {
        let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done
            , target: self, action: #selector(doneButtonAction))
        toolBar.setItems([flexSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        
        
        
        questionTextView.isEditable = false
        questionTextView.isScrollEnabled = true
        questionTextView.text = "placeHolder for text"
//        questionTextView.font = [UIFont size:25]
        
        
//        questionTextView.isUserInteractionEnabled = false
        
        textFieldAnswer.inputAccessoryView = toolBar
        textFieldPicker.inputAccessoryView = toolBar // тут, кажется, всё сломано
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }

}

