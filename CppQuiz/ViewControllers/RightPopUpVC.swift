//
//  PopUpViewController.swift
//  CppQuiz
//
//  Created by Always Strive And Prosper on 27.12.2019.
//  Copyright © 2019 komarov. All rights reserved.
//

import UIKit

class RightPopUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
    }
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func closePopUpButton() {
        self.removeAnimate()
//        self.view.removeFromSuperview()
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
