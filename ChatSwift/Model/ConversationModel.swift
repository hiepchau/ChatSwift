//
//  ConversationModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 09/12/2022.
//

import Foundation

final class ConversationModel : BaseModel, Identifiable {
    var conversationID: String { id }
    
    let id, name : String
    let users: [String]
    
    override init(){
        self.id = ""
        self.name = ""
        self.users = [""]
    }
    
    init(data: [String: Any?]) {
        self.id = data[Constant.CONVERSATION_ID] as? String ?? ""
        self.name = data[Constant.CONVERSATION_NAME] as? String ?? ""
        self.users = data[Constant.CONVERSATION_USERS] as? [String] ?? [""]
    }
    
    var dictionary: [String: Any] {
        return [Constant.CONVERSATION_ID: id,
                Constant.CONVERSATION_NAME: name,
                Constant.CONVERSATION_USERS: users]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}
