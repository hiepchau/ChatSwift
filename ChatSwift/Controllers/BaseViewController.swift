//
//  BaseViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 05/01/2023.
//

import Foundation
import JGProgressHUD
import UIKit

class BaseViewController: UIViewController, SetupViewController {
   
    func setupUI() {}
    func bindViewModel(){}
    
    let vm = BaseViewModel()
    
    let spinner = JGProgressHUD(style: .dark)
    
    func alertError(message: String) {
        let alert = UIAlertController(title: vm.alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: vm.actionTitle, style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

protocol SetupViewController {
    func setupUI()
    func bindViewModel()
}
