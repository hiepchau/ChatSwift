//
//  Constant.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 27/12/2022.
//

import Foundation

struct Constant {
    
    //FIRESTORE DOCUMENTS
    public static let USER = "user"
    public static let CONVERSATION = "conversation"
    public static let MESSAGE = "messages"
    
    //USER MODEL
    public static let USER_UID = "uid"
    public static let USER_USERNAME = "username"
    public static let USER_PASSWORD = "password"
    public static let USER_NAME = "name"
    public static let USER_ISONLINE = "isOnline"
    
    //CONVERSATION MODEL
    public static let CONVERSATION_ID = "id"
    public static let CONVERSATION_NAME = "name"
    public static let CONVERSATION_USERS = "users"

    //MESSAGE MODEL
    
    public static let EXT_INFO = [
        "appVersion": "1.0.0",
    ]
    public static let LOGIN_TOKEN_KEY = "LOGINTOKEN"
    public static let CUR_USER_KEY = "CURUSER"
    public static let ZALO_APP_ID = "3857990715579569034"
    
    public static let ZALO_USERNAME_TYPE: (String) -> (String) = { uid in
        return "zalo" + uid
    }
}

enum UserDefaultsKeys: String, CaseIterable {
    case refreshToken = "refreshToken"
    case accessToken = "accessToken"
    case expriedTime = "expriedTime"
}
