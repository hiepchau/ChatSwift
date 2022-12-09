//
//  UserModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 08/12/2022.
//

import Foundation

final class UserModel : BaseModel {
    
    let username: String
    
    init(data: [String: Any?]) {
        self.username = data["username"] as? String ?? ""
    }
    
    var dictionary: [String: Any?] {
        return ["username": username]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
    
}
