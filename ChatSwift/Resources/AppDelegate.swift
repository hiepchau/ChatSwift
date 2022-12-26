//
//  AppDelegate.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 07/12/2022.
//

import UIKit
import FirebaseCore
import FBSDKCoreKit
import GoogleSignIn
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    public var signInConfig: GIDConfiguration?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

//        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
//            if let user = user, error == nil {
//                self?.handleSessionRestore(user: user)
//            }
//        }

        if let clientId = FirebaseApp.app()?.options.clientID {
            signInConfig = GIDConfiguration.init(clientID: clientId)
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        return false
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func handleSessionRestore(user: GIDGoogleUser) {
        guard let uid = Auth.auth().currentUser?.uid,
            let email = user.profile?.email,
            let firstName = user.profile?.givenName,
            let lastName = user.profile?.familyName else {
                return
        }
        
        DatabaseManager.shared.userExists(with: email, completion: { exists in
            if !exists {
                // insert to database
                let userModel = UserModel(
                    uid: uid,
                    username: email,
                    name: lastName + " " + firstName
                )
                
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
        let curUser = UserModel(userGID: user)
        UserDefaults.standard.set(curUser.dictionary, forKey: "CURUSER")
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

}

