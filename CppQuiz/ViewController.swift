//
//  ViewController.swift
//  CppQuiz
//
//  Created by Always Strive n Prosper on 20/10/2019.
//  Copyright © 2019 komarov. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
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
    private var crutch = false

//    private var favoriteQuestionList = [Question]()
    private var questionList: [Question] = {
        func randomString(length: Int) -> String {
          let letters = "abcdefghijkl mnopqrstuvwxyz ABCDEFGHIJKLMN OPQRSTUVWXYZ 0123456789"
          return String((0..<length).map{ _ in letters.randomElement()! })
        }

        return (0...Int.random(in: 3...9)).map { _ in
            Question(correctAnswer: PickOption.allCases.randomElement()!.answer("test"),
                     questionBody: randomString(length: .random(in: 42...1000)), hint: "none", questionNumber: .random(in: 42...1000))
        }
    }()
    

    let someText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    var answerView : UIView? = nil
    let pickerView = UIPickerView()
    var currentPickOption: PickOption? {
        let row = self.pickerView.selectedRow(inComponent: 0)
        return row > 0 ? PickOption.allCases[row - 1] : nil
    }

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
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
        if bottomConstraint.constant == DEFAULT_CONSTRAINT_BOT {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                
                bottomConstraint.constant = keyboardSize.height + TOOLBAR_HEIGHT + DEFAULT_CONSTRAINT_BOT
            } //else {
//                 bottomConstraint.constant = 100
//            }
        }
    }
    
    

    @objc private func keyboardWillHide(notification: NSNotification) {
        if bottomConstraint.constant != DEFAULT_CONSTRAINT_BOT {
            bottomConstraint.constant = DEFAULT_CONSTRAINT_BOT
        }
    }
    
    
    @IBOutlet weak var skipButtonOutlet: UIButton!
    @IBOutlet weak var hintButtonOutlet: UIButton!
    @IBOutlet weak var giveUpButtonOutlet: UIButton!
    @IBOutlet weak var answerButtonOutlet: UIButton!
    
    private func displayQuestion(forQuestion question: Question) {
        questionTextView.text = question.questionBody
        navigationBar.title = "Question #\(question.questionNumber)"
        curQuestion = question
    }
    
    @IBAction func skipButton() {
        let randomQuestion = questionList.randomElement()!
        
        displayQuestion(forQuestion: randomQuestion)
        self.view.backgroundColor = UIColor.systemBackground
    }
    
    
    @IBAction func hintButton() {
        let hintPopUpVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HintPopUpVC")
        self.addChild(hintPopUpVC)
        hintPopUpVC.view.frame = self.view.frame
        self.view.addSubview(hintPopUpVC.view)
        hintPopUpVC.didMove(toParent: self)
    }
    
    @IBAction func answerButton() {
        if crutch {
            skipButton()
            return
        }
        
        let answer = self.currentPickOption?.answer(textFieldAnswer.text ?? "")
        if answer == curQuestion.correctAnswer {
            let rightPopUpVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RightPopUpVC")
            self.addChild(rightPopUpVC)
            rightPopUpVC.view.frame = self.view.frame
            self.view.addSubview(rightPopUpVC.view)
            rightPopUpVC.didMove(toParent: self)
            
            answerButtonOutlet.setTitle("Next!", for: .normal)
            self.view.backgroundColor = UIColor.green
            crutch = true
            
        } else {
            let wrongPopUpVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WrongPopUpVC")
            self.addChild(wrongPopUpVC)
            wrongPopUpVC.view.frame = self.view.frame
            self.view.addSubview(wrongPopUpVC.view)
            wrongPopUpVC.didMove(toParent: self)
            self.view.backgroundColor = UIColor.systemPink
        }
    }
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBAction func giveUpButton() {
        skipButton()
    }
    
    let TOOLBAR_HEIGHT: CGFloat = 30
    let DEFAULT_CONSTRAINT_BOT: CGFloat = 10
    private func setupTextFields() {
        let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: TOOLBAR_HEIGHT)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done
            , target: self, action: #selector(doneButtonAction))
        toolBar.setItems([flexSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        
        textFieldPicker.text = "Choose one..."
        
        questionTextView.isEditable = false
        questionTextView.isScrollEnabled = true
        
        answerButtonOutlet.backgroundColor = UIColor.white
        giveUpButtonOutlet.backgroundColor = UIColor.white
        hintButtonOutlet.backgroundColor = UIColor.white
        skipButtonOutlet.backgroundColor = UIColor.white
        
        
        textFieldAnswer.inputAccessoryView = toolBar
        textFieldPicker.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }

}


@available(iOS 13.0, *)
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PickOption.allCases.count + 1
    }
}

@available(iOS 13.0, *)
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
