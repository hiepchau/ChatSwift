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
    
    var window: UIWindow?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ///Config view
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        let mainNavigationController = UINavigationController(rootViewController: LoginViewController())
//        window.rootViewController = mainNavigationController
//        window.makeKeyAndVisible()
//
//        self.window = window

        ///Config Firebase
        FirebaseApp.configure()
        
        ///Config Zalo
        ZaloSDK.sharedInstance().initialize(withAppId: Constant.ZALO_APP_ID)

        ///Config Facebook
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
 
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ///Receive callback from Facebook
        ApplicationDelegate.shared.application(app, open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        ///Receive callback from Google
        GIDSignIn.sharedInstance.handle(url)
        ///Receive callback from zalo
        ZDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}




