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

    public static var curQuestion: Question!
    private var questionJsonList = [QuestionJson]()
    private var questionList = [Question]()
    
    func stringToPickOption(for string: String, with answer: String) -> Question.Answer {
        switch string {
        case "OK":
            return PickOption.OK.answer(answer)
        case "CE":
            return PickOption.CE.answer("🥵")
        case "US":
            return PickOption.UID.answer("🥵")
        default:
            return PickOption.UB.answer("🥵")
        }
    }
    
    func transform() {
        for i in 0..<questionJsonList.count {
            let cur = questionJsonList[i]
            questionList.append(Question(id: cur.id, questionBody: cur.question, result: stringToPickOption(for: cur.result, with: cur.answer), answer: cur.answer, explanation: cur.explanation, hint: cur.hint, difficulty: cur.difficulty))
        }
    }
    
    func loadData(completion: @escaping (_ success: Bool) -> Void) {
        let questionRequest = QuestionRequest()
        questionRequest.getQuestions { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let questions):
                    self!.questionJsonList = questions
                    completion(true)
                }
            }
        }
    }
    
    static var curIndex = 0
    var answerView : UIView? = nil
    var wrongAnswerView : UIView? = nil
    var rightAnswerView : UIView? = nil
    let pickerView = UIPickerView()
    var currentPickOption: PickOption? {
        let row = self.pickerView.selectedRow(inComponent: 0)
        return row > 0 ? PickOption.allCases[row - 1] : nil
    }

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crutchHint = true
                
        answerView = verticalStackView.arrangedSubviews[3]
        wrongAnswerView = verticalStackView.arrangedSubviews[1]
        rightAnswerView = verticalStackView.arrangedSubviews[0]
        answerView!.isHidden = true
        rightAnswerView!.isHidden = true
        wrongAnswerView!.isHidden = true
        setupTextFields()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.textFieldPicker.delegate = self
        

        
        textFieldPicker.inputView = pickerView
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        self.questionTextView.text = "Loading questions..."
        self.loadData{
            (success) -> Void in
            if success {
                self.transform()
                if UserDefaults.standard.value(forKey: "curQuestionId") == nil {
                    ViewController.curIndex = 0
                    self.displayQuestion(forQuestion: self.questionList.first!)
                    UserDefaults.standard.set(self.questionList.first!.id, forKey: "curQuestionId")
                } else {
                    var index = self.searchQuestionIndex(withId: UserDefaults.standard.value(forKey: "curQuestionId") as! Int)
                    if index == -1 {
                        index = 0
                    }
                    ViewController.self.curIndex = index
                    self.displayQuestion(forQuestion: self.questionList[index])
                }
            }
        }
    }

    func searchQuestionIndex(withId id: Int) -> Int {
        for i in 0..<questionList.count {
            if questionList[i].id == id {
                return i
            }
        }
        return -1
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        var value: CGFloat = 0 //compute constraint
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if (self.textFieldAnswer .isFirstResponder) {
                value = keyboardSize.height + TOOLBAR_HEIGHT + DEFAULT_CONSTRAINT_BOT + 30
            } else {
                value = keyboardSize.height + TOOLBAR_HEIGHT + DEFAULT_CONSTRAINT_BOT + 30 //TODO: (useless if)
            }
        }
        if bottomConstraint.constant == DEFAULT_CONSTRAINT_BOT {
            bottomConstraint.constant = value //change constraint
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    

    @objc private func keyboardWillHide(notification: NSNotification) {
        if bottomConstraint.constant != DEFAULT_CONSTRAINT_BOT {
            bottomConstraint.constant = DEFAULT_CONSTRAINT_BOT
        }
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    @IBOutlet weak var skipButtonOutlet: UIButton!
    @IBOutlet weak var hintButtonOutlet: UIButton!
    @IBOutlet weak var giveUpButtonOutlet: UIButton!
    @IBOutlet weak var answerButtonOutlet: UIButton!
    
    private func displayQuestion(forQuestion question: Question) {
        questionTextView.text = question.questionBody
        crutchHint = true
        navigationBar.title = "Question #\(question.id). Difficulty: \(question.difficulty). \(ViewController.curIndex + 1)/\(questionList.count)"
        ViewController.curQuestion = question
        UserDefaults.standard.set(ViewController.curQuestion.id, forKey: "curQuestionId")
    }
    
    func incrementCounter() {
        if ViewController.curIndex == questionList.count - 1 {
            ViewController.curIndex = 0
        } else {
            ViewController.curIndex += 1
        }
    }
    
    @IBAction func skipButton() {
        wrongAnswerView!.hideAnimated(in: verticalStackView)
        rightAnswerView!.hideAnimated(in: verticalStackView)
        incrementCounter()
        displayQuestion(forQuestion: questionList[ViewController.curIndex])
        textFieldAnswer.text = ""
        self.answerButtonOutlet.setTitle("Answer", for: .normal)
        self.view.backgroundColor = UIColor.systemBackground
    }
    
    
    @IBAction func hintButton() {
        if crutchHint {
            createAlertHint()
        } else {
            let hintPopUpVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HintPopUpVC")
            self.addChild(hintPopUpVC)
            hintPopUpVC.view.frame = self.view.frame
            self.view.addSubview(hintPopUpVC.view)
            hintPopUpVC.didMove(toParent: self)
        }
    }
    
    @IBAction func answerButton() {
        
        let answer = self.currentPickOption?.answer(textFieldAnswer.text ?? "")
        if answer == ViewController.curQuestion.result {
            rightAnswerView!.showAnimated(in: verticalStackView)
            wrongAnswerView!.hideAnimated(in: verticalStackView)
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destination = storyboard.instantiateViewController(withIdentifier: "AnswerView")
            navigationController?.pushViewController(destination, animated: true)
        } else {
            rightAnswerView!.hideAnimated(in: verticalStackView)
            wrongAnswerView!.showAnimated(in: verticalStackView)
            wrongAnswerView!.shake()
        }
    }
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBAction func giveUpButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "AnswerView")
        navigationController?.pushViewController(destination, animated: true)
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
    
    var crutchHint = true
    func createAlertHint() {
        let alert = UIAlertController(title: "Are you sure you want to view the hint?", message: "Have you really thought through the question?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "SHOW HINT", style: .default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            self.crutchHint = false
            let hintPopUpVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HintPopUpVC")
            self.addChild(hintPopUpVC)
            hintPopUpVC.view.frame = self.view.frame
            self.view.addSubview(hintPopUpVC.view)
            hintPopUpVC.didMove(toParent: self)
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
        if option != .OK {
            answerView!.hideAnimated(in: verticalStackView)
        } else {
            answerView!.showAnimated(in: verticalStackView)
        }
    }
}

@available(iOS 13.0, *)
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}


extension UIView {
    func hideAnimated(in stackView: UIStackView) {
        if !self.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = true
                    stackView.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }

    func showAnimated(in stackView: UIStackView) {
        if self.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = false
                    stackView.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        self.layer.add(animation, forKey: "shake")
    }
}

