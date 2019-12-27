//
//  ViewController.swift
//  CppQuiz
//
//  Created by Always Strive n Prosper on 20/10/2019.
//  Copyright © 2019 komarov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    enum PickOption: CaseIterable {
        case OK
        case CE
        case UID
        case UB

        var localizedName: String {
            switch self {
            case .OK: return "The program is guaranteed to output."
            case .CE: return "Compilation error."
            case .UID: return "Unspecified / Implementation defined."
            case .UB: return "Undefined behavior."
            }
        }

        func answer(_ text: String) -> Question.Answer {
            switch self {
            case .OK: return .output(text)
            case .CE: return .compilationError
            case .UID: return .unspecified
            case .UB: return .undefined
            }
        }
    }

    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var textFieldAnswer: UITextField!
    @IBOutlet weak var textFieldPicker: UITextField!
    @IBOutlet weak var verticalStackView: UIStackView!

    private var curQuestion: Question!

//    private var favoriteQuestionList = [Question]()
    private var questionList: [Question] = {
        func randomString(length: Int) -> String {
          let letters = "abcdefghijkl mnopqrstuvwxyz ABCDEFGHIJKLMN OPQRSTUVWXYZ 0123456789"
          return String((0..<length).map{ _ in letters.randomElement()! })
        }

        return (0...Int.random(in: 3...9)).map { _ in
            Question(correctAnswer: PickOption.allCases.randomElement()!.answer("test"),
                     questionBody: randomString(length: .random(in: 42...1000)), questionNumber: .random(in: 42...1000))
        }
    }()
    

    var someText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    var answerView : UIView? = nil
    let pickerView = UIPickerView()
    var currentPickOption: PickOption? {
        let row = self.pickerView.selectedRow(inComponent: 0)
        return row > 0 ? PickOption.allCases[row - 1] : nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        answerView = verticalStackView.arrangedSubviews[1]
        answerView!.isHidden = true
        setupTextFields()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        

        textFieldPicker.inputView = pickerView
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        displayQuestion(forQuestion: self.questionList.first!)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    

    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

//    private func textViewShouldBeginEditing(textField: UITextView) -> Bool {
//        if textField == questionTextView {
//            return false;
//        }
//        return true
//    }
    
    
    
    private func displayQuestion(forQuestion question: Question) {
        questionTextView.text = question.questionBody
        navigationBar.title = "Question #\(question.questionNumber)"
        curQuestion = question
    }
    
    @IBAction func skipButton() {
        let randomQuestion = questionList.randomElement()!
        displayQuestion(forQuestion: randomQuestion)
    }

    @IBAction func answerButton() {
        let answer = self.currentPickOption?.answer(textFieldPicker.text ?? "")
        if answer == curQuestion.correctAnswer {
            print("Correct Answer!")
            displayQuestion(forQuestion: questionList.randomElement()!)
        } else {
            print("Wrong Answer!")
        }
    }
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBAction func giveUpButton() {
        skipButton()
    }
    
    
    private func setupTextFields() {
        let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done
            , target: self, action: #selector(doneButtonAction))
        toolBar.setItems([flexSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        
        textFieldPicker.text = "Choose one..."
        
        questionTextView.isEditable = false
        questionTextView.isScrollEnabled = true
//        questionTextView.font = [UIFont size:25]
        
        
//        questionTextView.isUserInteractionEnabled = false
        
        textFieldAnswer.inputAccessoryView = toolBar
        textFieldPicker.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }

}


extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PickOption.allCases.count + 1
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row > 0 ? PickOption.allCases[row - 1].localizedName : nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let option = self.currentPickOption
        textFieldPicker.text = option?.localizedName ?? "Choose one answer..."
        answerView?.isHidden = option != .some(.OK)
    }
}
