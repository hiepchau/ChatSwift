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
import GoogleSignIn


class LoginTableViewController: UITableViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    private let spinner = JGProgressHUD(style: .dark)
    private var loginObserver: NSObjectProtocol?

//MARK: - LoadView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.performSegue(withIdentifier: "loginSegue", sender: self)
        })
        
        usernameField.delegate = self
        passwordField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
//MARK: -Func
    
    @IBAction func loginButtonDidTouch(){
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = usernameField.text, let password = passwordField.text, !email.isEmpty, password.count >= 6 else {
            alertUserLoginError(message: "Please fill information...")
            return
        }
        
        spinner.show(in: view)
   
        guard let username = usernameField.text, let password = passwordField.text else {
            return
        }
        
        DatabaseManager.shared.authenticate(username: username, password: password) {[weak self] isSuccess in
            
            guard let strongself = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongself.spinner.dismiss()
            }
            
            if isSuccess {
                let token = UserDefaults.standard.string(forKey: "LOGINTOKEN")
                let currentUser = UserDefaults.standard.dictionary(forKey: "CURUSER")
                print("Logged in with user: \(String(describing: currentUser)); Token: \(String(describing: token))")
                strongself.performSegue(withIdentifier: "loginSegue", sender: self)
            }
            else {
                strongself.alertUserLoginError(message: "That password doesn't look right")
                strongself.passwordField.text = nil
                print("Authenticate failed")
            }
        }
    }
    
    @IBAction func googleSignInDidTouch(_ sender: UIButton) {
        GoogleService.shared.login(vc: self, completion: {})
    }
    
    @IBAction func facebookSignInDidTouch(_ sender: UIButton) {
        FacebookService.shared.login(vc: self, completion: {})
    }
    
    @IBAction func zaloSignInButtonDidTouch(_ sender: UIButton){
        ZaloService.shared.login(vc: self, completion: {})
    }

    @IBAction func signupButtonDidTouch(_ sender: UIButton) {
        if let signupVC = self.storyboard?.instantiateViewController(identifier: "SignUpViewController") as? SignUpViewController{
//            signupVC.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(signupVC, animated: true)
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
            loginButtonDidTouch()
        }
        return true
    }
}
