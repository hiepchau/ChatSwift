//
//  ZaloService.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 27/12/2022.
//
import Foundation
import ZaloSDK
import FirebaseAuth

class ZaloService: Authenticate {
    static let shared = ZaloService()
    
    func login(vc: UIViewController, completion: @escaping() -> Void) {
        AuthenUtils.shared.renewPKCECode()
        ///Authenticate - get response
        ZaloSDK.sharedInstance().authenticateZalo(with: ZAZAloSDKAuthenTypeViaZaloAppAndWebView, parentController: vc, codeChallenge: AuthenUtils.shared.getCodeChallenge(), extInfo: Constant.EXT_INFO) { (response) in
            guard let response = response,
                  response.errorCode != -1001 else {
                print("Login with Zalo error: \(String(describing: response?.errorCode)), message:\(String(describing: response?.errorMessage))")
                completion()
                return
            }
            if response.isSucess {
                ///Get access token
                ZaloSDK.sharedInstance().getAccessToken(withOAuthCode: response.oauthCode, codeVerifier: AuthenUtils.shared.getCodeVerifier()) { tokenResponse in
                    AuthenUtils.shared.saveTokenResponse(tokenResponse)
                    guard let tokenResponse = tokenResponse,
                            let accessToken = tokenResponse.accessToken else {
                        print("Get AccessToken from OauthCode error \(tokenResponse?.errorCode ?? ZaloSDKErrorCode.sdkErrorCodeUnknownException.rawValue), message: \(tokenResponse?.errorMessage ?? "")")
                        completion()
                        return
                    }
                    ///Get  profile data
                    ZaloSDK.sharedInstance().getZaloUserProfile(withAccessToken: accessToken) { result in
                        guard let result = result,
                              result.isSucess,
                              let uid = result.data["id"] as? String,
                              let name = result.data["name"] as? String else {
                            completion()
                            return
                        }
                        let username = Constant.ZALO_USERNAME_TYPE(uid)
                        let userModel = UserModel(uid: uid,
                                                  username: username,
                                                  name: name,
                                                  isOnline: true)
                      
                        AuthenUtils.shared.loginHandle(with: uid, with: userModel)
                        print("Successfully logged user in with Zalo")

                    }
                }
            }
            else {
                print("Response failed")
                completion()
                return
            }
        }
    }
    
    func logout() {
        AuthenUtils.shared.tokenResponse = nil
        ZaloSDK.sharedInstance().unauthenticate()
    }
}

