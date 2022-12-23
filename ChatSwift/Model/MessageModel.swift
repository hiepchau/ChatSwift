//
//  MessagesModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 09/12/2022.
//

import Foundation
import CloudKit

public enum Kind {
    case text(String)
    case photo(URL)
}

struct Message {
    let id: String
    let senderID: String
    let sentDate: Date
    let kind: Kind
}

extension Kind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .photo(_):
            return "photo"
        }
    }
}

final class MessageModel: BaseModel{
    var id: String
    var conversationID: String
    var senderID: String
    var sentDate: Date
    var kind: String
    var content: String

    init(data: [String: Any?]) {
        self.id = data["id"] as? String ?? ""
        self.conversationID = data["conversationID"] as? String ?? ""
        self.senderID = data["senderID"] as? String ?? ""
        self.sentDate = data["sentDate"] as? Date ?? Date()
        self.kind = data["kind"] as? String ?? ""
        self.content = data["content"] as? String ?? ""
    }
    
    init(message: Message, conversationID: String){
        self.id = message.id
        self.conversationID = conversationID
        self.senderID = message.senderID
        self.sentDate = message.sentDate
        self.kind = message.kind.messageKindString
        var content = ""
        switch message.kind {
        case .text(let messageText):
            content = messageText
        case .photo(let url):
            content = url.absoluteString
            break
        }
        self.content = content
        super.init()
    }

    var dictionary: [String: Any] {
        return ["id": id,
                "conversationID": conversationID,
                "senderID": senderID,
                "sentDate": sentDate,
                "kind": kind,
                "content": content]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}
