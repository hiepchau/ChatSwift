//
//  AppDelegate.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 07/12/2022.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import FacebookCore
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    public var signInConfig: GIDConfiguration?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
//        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
//            if let user = user, error == nil {
//                self?.handleSessionRestore(user: user)
//            }
//        }
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        if let clientId = FirebaseApp.app()?.options.clientID {
            signInConfig = GIDConfiguration.init(clientID: clientId)
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        
        ApplicationDelegate.shared.application(app, open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
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
    
}



