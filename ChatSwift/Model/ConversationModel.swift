//
//  ConversationModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 09/12/2022.
//

import Foundation

final class ConversationModel : BaseModel {
    var userID: String?
    convenience init(userID: String?) {
        self.init()
        self.userID = userID
    }
}
