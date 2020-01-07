//
//  HintPopUpViewController.swift
//  CppQuiz
//
//  Created by Always Strive And Prosper on 27.12.2019.
//  Copyright © 2019 komarov. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class HintPopUpViewController: UIViewController {

    @IBOutlet weak var hintTextView: UITextView!
    
    @IBOutlet var centralView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralView.layer.cornerRadius = 17
        centralView.layer.masksToBounds = true
        
        hintTextView.isEditable = false
        hintTextView.isScrollEnabled = true
        hintTextView.text = "    " + ViewController.curQuestion.hint
        self.showAnimate()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        
    }
        
    @IBAction func closePopUpButton() {
        removeAnimate()
    }
    
        
        func showAnimate()
        {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            UIView.animate(withDuration: 0.25, animations: {
                self.view.alpha = 1.0
                self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            });
        }
        
        func removeAnimate()
        {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.view.alpha = 0.0;
                }, completion:{(finished : Bool)  in
                    if (finished)
                    {
                        self.view.removeFromSuperview()
                    }
            });
        }

}



