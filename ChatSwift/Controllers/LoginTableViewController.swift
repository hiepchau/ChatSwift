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
    
    let db = Firestore.firestore()

    
//MARK: - LoadView
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self

        // Do any additional setup after loading the view.
    }
    //TODO: setdata for firestore
    @IBAction func loginButtonTapped(){
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()

        guard let email = usernameField.text, let password = passwordField.text, !email.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
   
//        storeUserInformation()
        
        getUserData()
//        spinner.show(in: view)
//        performSegue(withIdentifier: "segue", sender: self)
    }
    
    private func storeUserInformation(){
        let userData = User(username: usernameField.text, password: passwordField.text)
        db.collection("users").document().setData(userData.dictionary as [String : Any]){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        print("ham` dc chay")
    }

    private func getUserData(){
        
//        db.collection("users").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print(document.data())
//                }
//            }
//        }
        // Create a reference to the cities collection
        let userRef = db.collection("users")

        // Create a query against the collection.
        let query = userRef.whereField("username", isEqualTo: usernameField.text!)
            .whereField("password", isEqualTo: passwordField.text!)
        
        
        query.getDocuments(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
//                    guard let refdata = document.data(), !refdata.isEmpty else{
//                        print("nothing")
//                    }
                    let flag = document.data().isEmpty
                    print(flag)
                    if flag{
                        print("nothing")
                    }
                    else {
                        print(document.data())
                    }
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
