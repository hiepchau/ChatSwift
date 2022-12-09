//
//  MessagesModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 09/12/2022.
//

import Foundation

final class MessagesModel: BaseModel{
    var conversationID: String?
    var userID: String?
    var text: String?
    
    convenience init(conversationID: String?, userID: String?, text: String?) {
        self.init()
        self.conversationID = conversationID
        self.userID = userID
        self.text = text
    }
}
