//
//  ConversationTableCellViewModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 03/01/2023.
//

import Foundation
import UIKit
class ConversationTableCellViewModel {
    
    var id: String
    var username: String
    var msg: String
    var imgView: UIImage?
    var isLogin: Bool
    
    init(conversation: ConversationModel) {
        self.id = conversation.conversationID
        self.username = conversation.name
        self.msg = "This is msg"
        self.imgView = UIImage(named: "profile")
        self.isLogin = false
    }
}
