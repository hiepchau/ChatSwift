//
//  Constant.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 27/12/2022.
//

import Foundation

struct Constant {
    public static let EXT_INFO = [
        "appVersion": "1.0.0",
    ]
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
