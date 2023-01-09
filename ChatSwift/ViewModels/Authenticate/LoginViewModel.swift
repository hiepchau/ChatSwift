//
//  LoginViewModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 29/12/2022.
//

import Foundation

class LoginViewModel: BaseViewModel {
    
    //MARK: - Variables
    
    private var username: String?
    private var password: String?
    
    var isPasswordTextFieldHighLighted: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String> = Observable(nil)
    
    //MARK: - Update variables
    
    override func setDynamicTextField(text: String?, tag: Int) {
        if tag == 0{
            username = text
        }
        else {
            password = text
        }
    }
    
    //MARK: - Function
    
    func login() {
        guard let username = username, let password = password,
              password.count >= 6 else {
            errorHandling(ErrorResult.custom(errMessage: "Invalid fields..."))
            NotificationCenter.default.post(name: .errorNotification, object: nil)
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
                NotificationCenter.default.post(name: .errorNotification, object: nil)
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
