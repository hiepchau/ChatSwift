//
//  LoginTableViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 08/12/2022.
//

import UIKit
import JGProgressHUD
import FirebaseCore
import FirebaseFirestore
import FirebaseAnalytics


class LoginTableViewController: UITableViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    private let spinner = JGProgressHUD(style: .dark)
    
//MARK: - LoadView
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self

        // Do any additional setup after loading the view.
    }
//MARK: -Func
    
    @IBAction func loginButtonTapped(){
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()

        guard let email = usernameField.text, let password = passwordField.text, !email.isEmpty, password.count >= 6 else {
            alertUserLoginError(message: "Please fill information...")
            return
        }
        
        spinner.show(in: view)
   
        DatabaseManager.shared.authenticate(username: usernameField.text!, password: passwordField.text!) { isSuccess in
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            if isSuccess {
                let token = UserDefaults.standard.string(forKey: "LOGINTOKEN")
                let currentUser = UserDefaults.standard.dictionary(forKey: "CURUSER")
                print("Logged in with user: \(String(describing: currentUser)); Token: \(String(describing: token))")
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            } else {
                self.alertUserLoginError(message: "That password doesn't look right")
                self.passwordField.text = nil
                print("Authenticate failed")
            }
        }
    }
    
    func alertUserLoginError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "TRY AGAIN", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
// MARK: - Extension

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
