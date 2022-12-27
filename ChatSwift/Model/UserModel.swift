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
    let username: String, name: String

    init(uid: String, username: String, name: String) {
        self.uid = uid
        self.username = username
        self.name = name
    }
    
    init(userGID: GIDGoogleUser) {
        self.uid = Auth.auth().currentUser?.uid ?? ""
        self.username = userGID.profile?.email ?? ""
        self.name = (userGID.profile?.givenName ?? "") + " " + (userGID.profile?.familyName ?? "")
        super.init()
    }
    
    init(data: [String: Any?]) {
        self.uid = data["uid"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
    }
    
//    init(dictionary: [String: Any]) throws {
//        self = try JSONDecoder().decode(UserModel.self, from: JSONSerialization.data(withJSONObject: dictionary))
//    }
//    private enum CodingKeys: String, CodingKey {
//        case number = "uid", name = "username"
//    }
    
    
    var dictionary: [String: String] {
        return ["uid": uid,
                "username": username,
                "name": name]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
    
}
