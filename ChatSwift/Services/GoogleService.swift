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

class GoogleService: Authenticate {
    static let shared = GoogleService()
    
    
    func login(vc: UIViewController, completion: @escaping () -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { (signInResult, error) in
            guard let signInResult = signInResult, error == nil else { return }
         
            self.handleSessionRestore(user: signInResult.user)
            let token = DatabaseManager.shared.currentID
            let currentUser = UserDefaults.standard.dictionary(forKey: Constant.CUR_USER_KEY)
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
        
        DatabaseManager.shared.checkUserExists(with: email, completion: { exists in
            if !exists {
                // insert to database
                DatabaseManager.shared.createUser(user: userModel, completion: {})
            }
        })
        
        guard let idToken = user.idToken else {
            return
        }

        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken.tokenString,
            accessToken: user.accessToken.tokenString
        )
        
        DatabaseManager.shared.currentID = uid
        UserDefaults.standard.set(userModel.dictionary, forKey: Constant.CUR_USER_KEY)
        
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
            guard authResult != nil, error == nil else {
                print("failed to log in with google credential")
                return
            }
            print("Successfully signed in with Google cred.")
            AuthenUtils.shared.printSession()
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
