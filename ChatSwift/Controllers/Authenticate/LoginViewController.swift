//
//  LoginViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 29/12/2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //ViewModel
    let viewModel = LoginViewModel()
    
    
    //Variables
    
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Text changed:
        
        ListenerService.shared.textWatcher(textField: usernameTextField, view: self, viewModel: viewModel)
        ListenerService.shared.textWatcher(textField: passwordTextField, view: self, viewModel: viewModel)
    }
    
    //MARK: - IBActions
    @IBAction func loginButtonDidTouch(_ sender: UIButton) {
        viewModel.login()
    }
    
    @IBAction func facebookButtonDidTouch(_ sender: UIButton) {
        viewModel.loginFacebook()
    }
    
    @IBAction func googleButtonDidTouch(_ sender: UIButton) {
        viewModel.loginGoogle()
    }
    
    @IBAction func zaloButtonDidTouch(_ sender: UIButton) {
        viewModel.loginZalo()
    }
    
    @IBAction func signupButtonDidTouch(_ sender: UIButton) {
        DispatchQueue.main.async {
            let controller = SignUpViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    //MARK: - Function

    
}

////MARK: - Extension
//extension LoginViewController : UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
//        if textField == usernameField {
//            passwordField.becomeFirstResponder()
//        }
//        else if textField == passwordField {
////            loginButtonDidTouch()
//        }
//        return true
//    }
//}

//MARK: - Text Field Delegate Methods
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        usernameTextField.layer.borderWidth = 0
        passwordTextField.layer.borderWidth = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
