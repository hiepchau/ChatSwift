//
//  ConversationModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 09/12/2022.
//

import Foundation

final class ConversationModel : BaseModel, Identifiable {
    var conversationID: String { id }
    
    let id , name: String
    var users = [UserModel]()
    
    init(data: [String: Any?]) {
        self.id = data["id"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
    }
    
    var dictionary: [String: String] {
        return ["id": id,
                "name": name]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}

