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
    
    var isUsernameTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isPasswordTextFieldHighLighted: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String> = Observable(nil)
    
    //MARK: - Update variables
    
    func observeTextChange(text: String?){
        self.username = text ?? ""
        self.password = text  ?? ""
    }
    
    
    //MARK: - Function
    
    func login() {
        guard !username.isEmpty, password.count >= 6 else {
//            alertUserLoginError(message: "Invalid fields...")
            errorHandling(ErrorResult.custom(errMessage: "Invalid fields..."))
            return
        }
        
        DatabaseManager.shared.authenticate(username: username, password: password) {[weak self] isSuccess in
            if isSuccess {
                let token = UserDefaults.standard.string(forKey: Constant.LOGIN_TOKEN_KEY)
                let currentUser = UserDefaults.standard.dictionary(forKey: Constant.CUR_USER_KEY)
                print("Logged in with user: \(String(describing: currentUser)); Token: \(String(describing: token))")
                NotificationCenter.default.post(name: .didLogInNotification, object: nil)
            }
            else {
                self?.errorHandling(ErrorResult.custom(errMessage: "That password doesn't look right"))
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
    
    private func errorHandling(_ error: ErrorResult) {
        switch error {
        case .network(let message):
            self.errorMessage.value = ErrorResult.network(errMessage: message).errorMessage
        case .parser(let message):
            self.errorMessage.value = ErrorResult.parser(errMessage: message).errorMessage
        case .custom(let message):
            self.errorMessage.value = ErrorResult.custom(errMessage: message).errorMessage
        }
    }
}
