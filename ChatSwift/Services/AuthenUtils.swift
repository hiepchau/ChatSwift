//
//  AuthenUtils.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 27/12/2022.
//

import Foundation
import ZaloSDK

protocol Authenticate {
    func login(vc: UIViewController, completion: @escaping () -> Void)
    func logout()
}

class AuthenUtils {

    static let shared = AuthenUtils()
    var tokenResponse: ZOTokenResponseObject?
    var codeChallenage = ""
    var codeVerifier = ""
    

    func getAccessToken(_ completionHandler: @escaping (String?) -> ()) {
        let now = TimeInterval(Date().timeIntervalSince1970 - 10)
        if let tokenResponse = tokenResponse,
           let accessToken = tokenResponse.accessToken, !accessToken.isEmpty,
           tokenResponse.expriedTime > now {

            completionHandler(accessToken)
            return
        }
        let refreshToken = UserDefaults.standard.string(forKey: UserDefaultsKeys.refreshToken.rawValue)
        ZaloSDK.sharedInstance().getAccessToken(withRefreshToken: refreshToken) { (response) in
            self.saveTokenResponse(response)
            completionHandler(response?.accessToken)
        }
    }

    func saveTokenResponse(_ tokenResponse: ZOTokenResponseObject?) {
        guard let tokenResponse = tokenResponse else {
            return
        }
        self.tokenResponse = tokenResponse
        let userDefault = UserDefaults.standard
        userDefault.set(tokenResponse.accessToken, forKey: UserDefaultsKeys.accessToken.rawValue)
        userDefault.set(tokenResponse.refreshToken, forKey: UserDefaultsKeys.refreshToken.rawValue)
    }
    
    func logout() {
        let allKeys = UserDefaultsKeys.allCases;
        let userDefault = UserDefaults.standard
        for key in allKeys {
            userDefault.removeObject(forKey: key.rawValue)
        }
    }
    
    func getCodeChallenge() -> String {
        return self.codeChallenage
    }
    
    func getCodeVerifier() -> String {
        return self.codeVerifier
    }
    
    func renewPKCECode() {
        self.codeVerifier = generateCodeVerifier() ?? ""
        self.codeChallenage = generateCodeChallenge(codeVerifier: self.codeVerifier) ?? ""
    }
    
    func printSession() {
        let curID = DatabaseManager.shared.currentID
        let currentUser = UserDefaults.standard.dictionary(forKey: Constant.CUR_USER_KEY)
        print("Logged in with user: \(String(describing: currentUser)), UID: \(String(describing: curID))")
    }
}
