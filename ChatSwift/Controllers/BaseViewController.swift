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
    
    let spinner = JGProgressHUD(style: .dark)
   
}

protocol SetupViewController {
    func setupUI()
    func bindViewModel()
}
