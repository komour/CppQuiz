//
//  MyЕableViewController.swift
//  CppQuiz
//
//  Created by Always Strive And Prosper on 27.12.2019.
//  Copyright © 2019 komarov. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        switch indexPath.row {
        case 0:
            let destination = storyboard.instantiateViewController(withIdentifier: "AboutViewController")
            navigationController?.pushViewController(destination, animated: true)
        case 1:
            let destination = storyboard.instantiateViewController(withIdentifier: "GoToQuesionViewController")
            navigationController?.pushViewController(destination, animated: true)
        default:
            print("default switch case in tableView dedSelectRowAt\n")
        }
    }
}
