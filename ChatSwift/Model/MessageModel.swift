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
        self.id = data[Constant.MESSAGE_ID] as? String ?? ""
        self.conversationID = data[Constant.MESSAGE_CONVERSATIONID] as? String ?? ""
        self.senderID = data[Constant.MESSAGE_SENDERID] as? String ?? ""
        self.sentDate = data[ Constant.MESSAGE_SENTDATE] as? Date ?? Date()
        self.kind = data[Constant.MESSAGE_KIND] as? String ?? ""
        self.content = data[Constant.MESSAGE_CONTENT] as? String ?? ""
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
        return [Constant.MESSAGE_ID: id,
                Constant.MESSAGE_CONVERSATIONID: conversationID,
                Constant.MESSAGE_SENDERID: senderID,
                Constant.MESSAGE_SENTDATE: sentDate,
                Constant.MESSAGE_KIND: kind,
                Constant.MESSAGE_CONTENT: content]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}
