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
    private var errorObserver: NSObjectProtocol?
    //ViewModel
    let viewModel = LoginViewModel()

    //Variables
    
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()


    }
    
    override func setupUI() {
        ///Observer
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongself = self else {
                return
            }
            strongself.navigate()
        })
        
        errorObserver = NotificationCenter.default.addObserver(forName: .errorNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongself = self else {
                return
            }
            strongself.viewModel.errorMessage.bind { [weak self] error in
                guard let error = error else { return }
                self?.alertUserLoginError(message: error)
            }
        })
        
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
            self.navigationController?.pushViewController(controller, animated: false)
        }
    }
    
    func alertUserLoginError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "TRY AGAIN", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func navigate(){
        usernameTextField.text = nil
        passwordTextField.text = nil
        let vc = ConversationViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - Text Field Delegate Methods
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
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
