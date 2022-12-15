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

struct Location: LocationItem {
    var location: CLLocation
    var size: CGSize
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
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
        self.id = message.messageId
        self.conversationID = conversationID
        self.senderID = message.sender.senderId
        self.sentDate = message.sentDate
        var tempkind = "text"
        var content = ""
        switch message.kind {
        case .text(let messageText):
            tempkind = "text"
            content = messageText
        case .attributedText(_):
            break
        case .photo(let mediaItem):
            tempkind = "photo"
            if let targetUrlString = mediaItem.url?.absoluteString {
                content = targetUrlString
            }
            break
        case .video(let mediaItem):
            tempkind = "video"
            if let targetUrlString = mediaItem.url?.absoluteString {
                content = targetUrlString
            }
            break
        case .location(let locationData):
            tempkind = "location"
            let location = locationData.location
            content = "\(location.coordinate.longitude),\(location.coordinate.latitude)"
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .custom(_), .linkPreview(_):
            break
        }
        self.kind = tempkind
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
