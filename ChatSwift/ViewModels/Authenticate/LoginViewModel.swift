//
//  LoginViewModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 29/12/2022.
//

import Foundation

class LoginViewModel: BaseViewModel {
    
    //MARK: - Variables
    private var username = ""

    private var password = ""
    
    var credentialsInputErrorMessage: Observable<String> = Observable("")
    var isUsernameTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isPasswordTextFieldHighLighted: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    //MARK: - Update variables
    
    func observeTextChange(text: String?){
        self.username = text ?? ""
        self.password = text  ?? ""
    }
    
    
    //MARK: - Function
    
    func login() {
        DatabaseManager.shared.authenticate(username: username, password: password) { isSuccess in
            if isSuccess {
                let token = UserDefaults.standard.string(forKey: Constant.LOGIN_TOKEN_KEY)
                let currentUser = UserDefaults.standard.dictionary(forKey: Constant.CUR_USER_KEY)
                print("Logged in with user: \(String(describing: currentUser)); Token: \(String(describing: token))")
            }
            else {
                print("Authenticate failed")
            }
        }
    }

    
    func loginFacebook() {
        FacebookService.shared.login(vc: LoginViewController(), completion: {})
    }
    
    func loginGoogle() {
        GoogleService.shared.login(vc: LoginViewController(), completion: {})
    }
    
    
    func loginZalo() {
        ZaloService.shared.login(vc: LoginViewController(), completion: {})
    }
    
    func credentialsInput() -> CredentialsInputStatus {
        if username.isEmpty && password.isEmpty {
            credentialsInputErrorMessage.value = "Please provide username and password."
            return .Incorrect
        }
        if username.isEmpty {
            credentialsInputErrorMessage.value = "Username field is empty."
            isUsernameTextFieldHighLighted.value = true
            return .Incorrect
        }
        if password.isEmpty {
            credentialsInputErrorMessage.value = "Password field is empty."
            isPasswordTextFieldHighLighted.value = true
            return .Incorrect
        }
        return .Correct
    }
    
}

//MARK: - extension

extension LoginViewModel {
    enum CredentialsInputStatus {
        case Correct
        case Incorrect
    }
}
