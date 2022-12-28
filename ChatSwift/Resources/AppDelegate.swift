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
import ZaloSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    public var signInConfig: GIDConfiguration?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ///Config Firebase
        FirebaseApp.configure()
        ZaloSDK.sharedInstance().initialize(withAppId: Constant.ZALO_APP_ID)

        ///Config Facebook
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        if let clientId = FirebaseApp.app()?.options.clientID {
            signInConfig = GIDConfiguration.init(clientID: clientId)
        }
        /* Save google login
         GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
             if let user = user, error == nil {
                 self?.handleSessionRestore(user: user)
             }
         }
         */
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ///Receive callback from Google
        GIDSignIn.sharedInstance.handle(url)
        ///Receive callback from Facebook
        ApplicationDelegate.shared.application(app, open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        ///Receive callback from zalo
        ZDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
}



