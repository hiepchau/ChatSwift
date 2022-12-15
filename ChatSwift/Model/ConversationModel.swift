//
//  ConversationModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 09/12/2022.
//

import Foundation

final class ConversationModel : BaseModel, Identifiable {
    var conversationID: String { id }
    
    let id , name : String
    let users: [String]
    
    override init(){
        self.id = ""
        self.name = ""
        self.users = [""]
    }
    
    init(data: [String: Any?]) {
        self.id = data["id"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.users = data["users"] as? [String] ?? [""]
    }
    
    var dictionary: [String: Any] {
        return ["id": id,
                "name": name,
                "users": users]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}
