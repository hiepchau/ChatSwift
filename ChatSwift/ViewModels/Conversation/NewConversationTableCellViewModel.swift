//
//  NewConversationTableCellViewModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 04/01/2023.
//

import Foundation

class NewConversationTableCellViewModel: BaseViewModel {
    var username: String
    
    init(user: UserModel){
        self.username = user.username
    }
}
