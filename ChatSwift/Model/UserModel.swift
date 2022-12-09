//
//  UserModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 08/12/2022.
//

import Foundation

final class UserModel : BaseModel {
    var username: String?
    var password: String?
    
    convenience init(username: String?, password: String?) {
        self.init()
        self.username = username
        self.password = password
    }
    
    var dictionary: [String: Any?] {
        return ["username": username,
                "password": password]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
    
}
