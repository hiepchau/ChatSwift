//
//  UserModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 08/12/2022.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

final class UserModel : BaseModel, Identifiable, Codable {
    var id: String { uid }
    
    let uid: String
    let username: String
    let name: String
    var isOnline: Bool
    
    init(uid: String, username: String, name: String, isOnline: Bool) {
        self.uid = uid
        self.username = username
        self.name = name
        self.isOnline = isOnline
    }
    
    init(data: [String: Any?]) {
        self.uid = data[Constant.USER_UID] as? String ?? ""
        self.username = data[Constant.USER_USERNAME] as? String ?? ""
        self.name = data[Constant.USER_NAME] as? String ?? ""
        self.isOnline = false
        super.init()
        if let temp = data[Constant.USER_ISONLINE] as? Int {
            self.isOnline = temp != 0
        }
    }
    
    var dictionary: [String: Any] {
        return [Constant.USER_UID: uid,
                Constant.USER_USERNAME: username,
                Constant.USER_NAME: name,
                Constant.USER_ISONLINE: isOnline]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
    
}
