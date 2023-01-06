//
//  LoginViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 29/12/2022.
//

import UIKit

class LoginViewController: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private var loginObserver: NSObjectProtocol?
    //ViewModel
    let viewModel = LoginViewModel()

    //Variables
    
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongself = self else {
                return
            }
            strongself.navigate()
        })
        
        ///Text changed:
        ListenerService.shared.textWatcher(textField: usernameTextField, view: self, viewModel: viewModel)
        ListenerService.shared.textWatcher(textField: passwordTextField, view: self, viewModel: viewModel)
    }
    
    //MARK: - IBActions
    @IBAction func loginButtonDidTouch(_ sender: UIButton) {
        viewModel.login()
        self.viewModel.errorMessage.bind { [weak self] error in
            self?.alertUserLoginError(message: error ?? "Oops, something went wrong!")
        }
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
    
    func alertUserLoginError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "TRY AGAIN", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func navigate(){
        let vc = ConversationViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


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
