//
//  AboutViewController.swift
//  CppQuiz
//
//  Created by Always Strive And Prosper on 27.12.2019.
//  Copyright © 2019 komarov. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    

    @IBOutlet weak var aboutTextField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutTextField.text = "Questions and game logic were taken from the site cppquiz.org created by\nAndreas Schau Knatten"
    }


    
}
