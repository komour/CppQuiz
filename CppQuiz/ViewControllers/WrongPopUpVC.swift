//
//  WrongPopUpVC.swift
//  CppQuiz
//
//  Created by Always Strive And Prosper on 27.12.2019.
//  Copyright © 2019 komarov. All rights reserved.
//

import UIKit

class WrongPopUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    @IBAction func closeButton() {
        self.view.removeFromSuperview()
    }
    
}
