//
//  ChatTableCellViewModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 04/01/2023.
//

import Foundation

class ChatTableCellViewModel {
    
    var id: String
    var msg: Any?
    var url: URL?
    var isSender: Bool
    var kind: Kind
    
    init(message: Message){
        self.id = message.id
        self.isSender = (message.senderID == DatabaseManager.shared.currentID)
        self.kind = message.kind
        switch message.kind {
        case .text(let text):
            self.msg = text
        case .photo(let url):
            self.msg = url
        }
    }
}
