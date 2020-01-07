//
//  GoToQuesionViewController.swift
//  CppQuiz
//
//  Created by Always Strive And Prosper on 06.01.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class GoToQuesionViewController: UIViewController {    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupToolBar()
    }
    
    func setupToolBar() {
        let TOOLBAR_HEIGHT: CGFloat = 30
        let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: TOOLBAR_HEIGHT)))
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .done
                , target: self, action: #selector(doneButtonAction))
            toolBar.setItems([flexSpace, doneButton], animated: false)
            toolBar.sizeToFit()
        goToQuestionByIdTextField.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    public static var idSet = Set<String>()
    
    @IBOutlet var goToQuestionByIdTextField: UITextField!
    @IBAction func goToQuestionByIdButton() {
        let idInTextField = goToQuestionByIdTextField.text ?? ""
        if GoToQuesionViewController.idSet.contains(idInTextField) {
            let id = Int(goToQuestionByIdTextField.text ?? "106")
            UserDefaults.standard.set(id, forKey: "curQuestionId")
            presentMainVC()
        } else {
            createAlertInvalidId()
            self.view.endEditing(true)
        }
    }
    
    func createAlertInvalidId() {
        let alert = UIAlertController(title: "WARNING", message: "Invalid question ID (try \(GoToQuesionViewController.idSet.randomElement()!)).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
        func presentMainVC() {
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let mainVC = storyBoard.instantiateViewController(withIdentifier: "QuizMainTabsVC")
            mainVC.modalPresentationStyle = .fullScreen
            self.present(mainVC, animated:true, completion:nil)
        }
    }

}


