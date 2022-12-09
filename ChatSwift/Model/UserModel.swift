//
//  UserModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 08/12/2022.
//

import Foundation



final class UserModel : BaseModel, Identifiable, Codable {
    var id: String { uid }
    
    let uid: String
    let username: String

    init(data: [String: Any?]) {
        self.uid = data["uid"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
    }
    
//    init(dictionary: [String: Any]) throws {
//        self = try JSONDecoder().decode(UserModel.self, from: JSONSerialization.data(withJSONObject: dictionary))
//    }
//    private enum CodingKeys: String, CodingKey {
//        case number = "uid", name = "username"
//    }
    
    
    var dictionary: [String: String] {
        return ["uid": uid,
                "username": username]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
    
}
