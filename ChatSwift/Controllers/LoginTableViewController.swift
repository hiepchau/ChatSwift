//
//  LoginTableViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 08/12/2022.
//

import UIKit
import JGProgressHUD
class LoginTableViewController: UITableViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    private let spinner = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(){
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let email = usernameField.text, let password = passwordField.text, !email.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
//        spinner.show(in: view)
//        performSegue(withIdentifier: "segue", sender: self)
    }
    

    func alertUserLoginError() {
        let alert = UIAlertController(title: "Error", message: "Please fill information", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension LoginTableViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == usernameField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }
}
