//
//  DatabaseManager.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 09/12/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import UIKit
import GoogleSignIn
import FirebaseAuth

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    var currentID: String? {
        get {
            guard let currentID = UserDefaults.standard.string(forKey: Constant.LOGIN_TOKEN_KEY) else {return nil}
            return currentID
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constant.LOGIN_TOKEN_KEY)
        }
    }

    var currentUser: [String: Any]? {
        get {
            guard let currentUser = UserDefaults.standard.dictionary(forKey: Constant.CUR_USER_KEY) else {return nil}
            return currentUser
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constant.CUR_USER_KEY)
        }
    }
    
    private let _userRef = Firestore.firestore().collection(Constant.USER)
    private let _conversationRef = Firestore.firestore().collection(Constant.CONVERSATION)
    private let _messageRef = Firestore.firestore().collection(Constant.MESSAGE)

    public enum DatabaseError: Error {
        case failedToFetch

        public var localizedDescription: String {
            switch self {
            case .failedToFetch:
                return "Failed to fetch data"
            }
        }
    }
}

//MARK: - Authenticate, users
extension DatabaseManager {

    public func authenticate(username: String?, password: String?, completion: @escaping (Bool) -> Void) {

        guard let username = username, let password = password else {
            completion(false)
            return
        }
        
        let query = _userRef.whereField(Constant.USER_USERNAME, isEqualTo: username)
            .whereField(Constant.USER_PASSWORD, isEqualTo: password)
        query.getDocuments(completion: {[weak self] (querySnapshot, err) in
            guard let strongself = self else { return }
            if let error = err {
                print("Error getting documents: \(error)")
                completion(false)
                return
            }
            guard let querySnapshot = querySnapshot, let document = querySnapshot.documents.first else {
                completion(false)
                return
            }
            
            strongself.setStateIsOnline(id: document.documentID, isOnline: true)
            ///Set UserDefaults
            strongself.currentID = document.documentID
            /// SetState
            let curUser = UserModel(data: document.data())
            ///Set current user
            strongself.currentUser = curUser.dictionary

            completion(true)
        })
    }
    
    public func createUser(user: UserModel, completion: @escaping () -> Void) {
        _userRef.document(user.uid).setData(user.dictionary) {err in
            if let err = err {
                print("Error writing user: \(err)")
                completion()
                return
            }
            print("User successfully written!")
            completion()
        }
    }
    
    public func checkUserExists(with uid: String,
                           completion: @escaping ((Bool) -> Void)) {
        let query = _userRef.document(uid)
        query.getDocument { (querySnapshot, err) in
            if let documentSnapshot = querySnapshot?.exists,
               !documentSnapshot {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func getUserByID(uid: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        let query = _userRef.document(uid)
         query.getDocument(completion: { (querySnapshot, err) in
             if let err = err  {
                 print("Error getting documents: \(err)")
                 completion(.failure(err))
                 return
             }
             guard let querySnapshot = querySnapshot, let data = querySnapshot.data() else {
                 return
             }
             completion(.success(UserModel(data: data)))

         })
     }
    
    public func getAllUsers(completion: @escaping (Result<[UserModel], Error>) -> Void) {
        var listUsers = [UserModel]()
        
        //Get user list
        _userRef.addSnapshotListener { (querySnapshot, err) in
            if let _ = err{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            listUsers = []
            guard let querySnapshot = querySnapshot else { return }
            for document in querySnapshot.documents {
                listUsers.append(.init(data: document.data()))
            }
            completion(.success(listUsers))
        }
    }
    // MARK: Update State
    func setStateIsOnline(id: String, isOnline: Bool) {
        _userRef.document(id).updateData([Constant.USER_ISONLINE : isOnline])
    }
}
//MARK: - Conversation
extension DatabaseManager {
    public func createNewConversation(result: [String: Any], completion: @escaping (Bool, String) -> Void) {
        var arrayUser = [String]()
        if let currentID = currentID {
            arrayUser.append(currentID)
        }
        //Create new Conversation
        let uuid = UUID().uuidString
        if let unwrappedUid = result[Constant.USER_UID],
           var name = result[Constant.USER_NAME],
            let unwrappedUid = unwrappedUid as? String {
            arrayUser.append(unwrappedUid)
            
            name = (currentID == unwrappedUid) ? "self" : name

            let documentData: [String: Any] = [Constant.CONVERSATION_ID: uuid,
                                               Constant.CONVERSATION_NAME: name,
                                               Constant.CONVERSATION_USERS: arrayUser]
            
            _conversationRef.document(uuid).setData(documentData){ err in
                if let _ = err  {
                    completion(false, "")
                    return
                }
               print("Conversation successfully written: \(uuid)!")
               completion(true, uuid)
            }
        }
    }
    
    private func getConversationByID(id: String, completion: @escaping(Result<ConversationModel, Error>) -> Void){
        _conversationRef.whereField(Constant.CONVERSATION_ID, isEqualTo: id).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting conversation: \(err)")
                completion(.failure(err))
                return
            }
            guard let querySnapshot = querySnapshot, let document = querySnapshot.documents.first else {
                return
            }
            completion(.success(ConversationModel(data: document.data())))
        }
    }
    
    public func getAllConversation(completion: @escaping (Result<[ConversationModel], Error>) -> Void){
        var listConversation = [ConversationModel]()
        
        //Get conversation list
        _conversationRef.whereField(Constant.CONVERSATION_USERS, arrayContainsAny: [currentID as Any]).addSnapshotListener { (querySnapshot, err) in
            if let _ = err {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            print("CONVERSATION OF USER: \(String(describing: self.currentID))")
            ///Get conversation data
            listConversation = []
       
            guard let querySnapshot = querySnapshot else { return }
            
            for document in querySnapshot.documents{
                listConversation.append(ConversationModel(data: document.data()))
            }
            completion(.success(listConversation))
        }
    }
}

//MARK: - Messages

extension DatabaseManager {
    
    ///CREATE
    public func createNewMessage(sendMsg: Message, conversationID: String, completion: @escaping(Bool) -> Void){
        let data = MessageModel(message: sendMsg, conversationID: conversationID)
        _messageRef.document(sendMsg.id).setData(data.dictionary){ err in
            if let err = err {
                print("Error writing document: \(err)")
                completion(false)
            }
            print("Message successfully written!")
            completion(true)
        }
    }
    
    ///GET
    public func getAllMessages(currentConversationID: String, completion: @escaping(Result<[Message], Error>) -> Void){
        var listMessages = [Message]()
        let query = _messageRef.whereField("conversationID", isEqualTo: currentConversationID).order(by: "sentDate")

        //Listen for msg
        query.addSnapshotListener { querySnapshot, err in
            if let err = err {
                completion(.failure(err))
                return
            }
            //Get msg
            guard let querySnapshot = querySnapshot, let currentID = self.currentID else {
                return
            }
            querySnapshot.documentChanges.forEach({ change in
                if change.type == .added {
                    let resMessage = MessageModel(data: change.document.data())
                    var currKind: Kind
                    let sender = (resMessage.id == currentID) ? currentID : resMessage.senderID
                    switch resMessage.kind {
                    case "photo":
                        guard let imageUrl = URL(string: resMessage.content) else {
                            return
                        }
                        currKind = .photo(imageUrl)
                    
                    default:
                        currKind = .text(resMessage.content)
                    }
                    
                    //apend
                    listMessages.append(Message(id: resMessage.id,
                                                senderID: sender,
                                                sentDate: resMessage.sentDate,
                                                kind: currKind))
                }
            })
            completion(.success(listMessages))
        }
    }
}



