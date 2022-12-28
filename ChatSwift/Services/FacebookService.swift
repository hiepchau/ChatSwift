//
//  FacebookService.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 27/12/2022.
//

import Foundation
import FirebaseAuth
import FBSDKLoginKit
import FacebookLogin
import FacebookCore

class FacebookService: Authenticate {

    static let shared = FacebookService()
    private let loginManager = LoginManager()
    
    func login(vc: UIViewController, completion: @escaping () -> Void) {
        loginManager.logIn(permissions: ["email"], viewController: vc) { result in
            switch result {
            case .success(granted: _, declined: _, token: let token):
                let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                                 parameters: ["fields":
                                                                    "email, first_name, last_name, picture.type(large)"],
                                                                 tokenString: token.tokenString,
                                                                 version: nil,
                                                                 httpMethod: .get)
                facebookRequest.start(completionHandler: {[weak self] _, result, err in
                    guard let strongself = self,
                        let result = result as? [String: Any],
                            err == nil else {
                        print("Failed to make facebook graph request")
                        completion()
                        return
                    }
                    print(result)
                    strongself.handleSessionRestore(result: result, token: token.tokenString)
                    completion()
                })
            default:
                break
            }
        }
    }
    
    private func handleSessionRestore(result: [String: Any], token: String){
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
            guard authResult != nil, error == nil else {
                if let error = error {
                    print("Facebook credential login failed, MFA may be needed - \(error)")
                }
                return
            }
            guard let uid = Auth.auth().currentUser?.uid,
                let firstName = result["first_name"] as? String,
                let lastName = result["last_name"] as? String,
                let email = result["email"] as? String else {
                    print("Failed to get email and name from fb result")
                    return
            }
            let userModel = UserModel(
                uid: uid,
                username: email,
                name: lastName + " " + firstName
            )
            DatabaseManager.shared.userExists(with: email, completion: { exists in
                if !exists {
                    ///Insert to db
                    DatabaseManager.shared.createUser(user: userModel, completion: {})
                }
            })
            DatabaseManager.shared.currentID = uid
            UserDefaults.standard.set(userModel.dictionary, forKey: Constant.CUR_USER_KEY)
            print("Successfully logged user in with Facebook cred")
            AuthenUtils.shared.printSession()
            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
        })
    }
    func logout() {
        FBSDKLoginKit.LoginManager().logOut()
    }
}
