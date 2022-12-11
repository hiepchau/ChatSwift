//
//  ConversationModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 09/12/2022.
//

import Foundation

final class ConversationModel : BaseModel {
    
    let id , name: String
    var users = [UserModel]()
    
    init(data: [String: Any?]) {
        self.id = data["id"] as? String ?? ""
        self.users = data["users"] as? [UserModel] ?? []
        self.name = data["name"] as? String ?? ""
    }
    
    var dictionary: [String: Any] {
        return ["id": id,
                "users": users,
                "name": name]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}

