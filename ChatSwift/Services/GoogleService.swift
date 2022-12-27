//
//  GoogleService.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 27/12/2022.
//

import Foundation
import Foundation
import Firebase
import GoogleSignIn

class GoogleService {
    static let shared = GoogleService()
    
    
    func login(vc: UIViewController, completion: @escaping () -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let signInConfig = appDelegate.signInConfig else {
            completion()
            return
        }
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: vc) { (user, error) in
            guard let user = user, error == nil else { return }
            self.handleSessionRestore(user: user)
            let token = DatabaseManager.shared.currentID
            let currentUser = UserDefaults.standard.dictionary(forKey: "CURUSER")
            print("Logged in with user: \(String(describing: currentUser)); Token: \(String(describing: token))")
            completion()
        }
    }
    
    private func handleSessionRestore(user: GIDGoogleUser) {
        guard let uid = Auth.auth().currentUser?.uid,
            let email = user.profile?.email,
            let firstName = user.profile?.givenName,
            let lastName = user.profile?.familyName else {
                return
        }
        
        let userModel = UserModel(uid: uid,
                                   username: email,
                                   name: lastName + " " + firstName)
        
        DatabaseManager.shared.userExists(with: email, completion: { exists in
            if !exists {
                // insert to database
                DatabaseManager.shared.createUser(user: userModel, completion: {})
            }
        })

        let authentication = user.authentication
        guard let idToken = authentication.idToken else {
            return
        }

        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: authentication.accessToken
        )
        
        UserDefaults.standard.set(uid, forKey: "LOGINTOKEN")
        UserDefaults.standard.set(userModel.dictionary, forKey: "CURUSER")
        
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
            guard authResult != nil, error == nil else {
                print("failed to log in with google credential")
                return
            }
            print("Successfully signed in with Google cred.")
            let token = DatabaseManager.shared.currentID
            let currentUser = UserDefaults.standard.dictionary(forKey: "CURUSER")
            print("Logged in with user: \(String(describing: currentUser)); Token: \(String(describing: token))")
            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
        })
    }
    
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch _ as NSError {
            return
        }
    }
}
