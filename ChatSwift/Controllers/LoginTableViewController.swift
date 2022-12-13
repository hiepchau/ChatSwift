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
            alertUserLoginError()
            return
        }
        
        spinner.show(in: view)
   
        let userRef = DatabaseManager.shared.db.collection("user")

        // Create a query against the collection.
        let query = userRef.whereField("username", isEqualTo: usernameField.text!)
            .whereField("password", isEqualTo: passwordField.text!)
        
        query.getDocuments(completion: { [self](querySnapshot, err) in
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                        
                    UserDefaults.standard.set(document.documentID, forKey: "LOGINTOKEN")
                    let token = UserDefaults.standard.string(forKey: "LOGINTOKEN")
                    let tempUser = UserModel(data: document.data())
                    UserDefaults.standard.set(tempUser.dictionary, forKey: "CURUSER")
                    let currentUser = UserDefaults.standard.dictionary(forKey: "CURUSER")
                    print("Logged in with user: \(currentUser!); Token: \(String(describing: token))")
                    performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }
        })
    }
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Error", message: "Please fill information", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: nil))
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
