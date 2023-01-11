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
    var users: [String]
    
    init(conversation: ConversationModel) {
        self.id = conversation.conversationID
        self.username = conversation.name
        self.msg = "This is msg"
        self.imgView = UIImage(named: "profile")
        self.users = conversation.users
    }
    
    func isOnline(completion: @escaping (Bool) -> Void) {
        for userID in self.users {
            if(DatabaseManager.shared.currentID != userID) {
                DatabaseManager.shared.getUserByID(uid: userID) { result in
                    switch result {
                    case.success(let userData):
                        print("Get user data susccess, ID: \(userData.uid), isOnline: \(userData.isOnline)")
                        completion(userData.isOnline)
                    case.failure(let error):
                        print("Failed to get user: \(error)")
                        completion(false)
                    }
                }
            }
            else {
                completion(true)
            }
        }
    }
}
