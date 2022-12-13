//
//  MessagesModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 09/12/2022.
//

import Foundation
import MessageKit
import InputBarAccessoryView
import CloudKit



struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
struct Sender: SenderType{
    var senderId: String
    var displayName: String
}

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .custom(_):
            return "customc"
        case .linkPreview(_):
            return "link"
        }
    }
}


final class MessageModel: BaseModel{
    var id: String
    var conversationID: String
    var senderID: String
    var text: String
    var sentDate: Date
    
//    convenience init(messageId: String?, conversationID: String?, senderID: String?, text: String?, sendDate: Date?) {
//        self.init()
//        self.id = messageId
//        self.conversationID = conversationID
//        self.senderID = senderID
//        self.text = text
//        self.sentDate = sendDate
//    }
    
    init(data: [String: Any?]) {
        self.id = data["id"] as? String ?? ""
        self.conversationID = data["conversationID"] as? String ?? ""
        self.senderID = data["senderID"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.sentDate = data["sentDate"] as? Date ?? Date()
    }
    
    init(message: Message, conversationID: String, text: String){
        self.id = message.messageId
        self.conversationID = conversationID
        self.senderID = message.sender.senderId
        self.text = text
        self.sentDate = message.sentDate
        super.init()
    }
    
    var dictionary: [String: Any] {
        return ["id": id,
                "conversationID": conversationID,
                "senderID": senderID,
                "text": text,
                "sentDate": sentDate]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}

