//
//  NewConversationTableCellViewModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 04/01/2023.
//

import Foundation

class NewConversationTableCellViewModel: BaseViewModel {
    var id: String
    var name: String
    
    init(user: UserModel){
        self.id = user.id
        self.name = user.name
    }
}
