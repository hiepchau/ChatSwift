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
import CoreLocation
import MessageKit

class DatabaseManager {
    static let shared = DatabaseManager()
    var currentID = UserDefaults.standard.string(forKey: "LOGINTOKEN")

    let db: Firestore

    init(){
        self.db = Firestore.firestore()
    }
    
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
        let userRef = db.collection("user")
        // Create a query against the collection.
        let query = userRef.whereField("username", isEqualTo: username!)
            .whereField("password", isEqualTo: password!)
        query.getDocuments(completion: { (querySnapshot, err) in
            if let error = err {
                print("Error getting documents: \(error)")
                completion(false)
                return
            } else {
                for document in querySnapshot!.documents {
                    UserDefaults.standard.set(document.documentID, forKey: "LOGINTOKEN")
                    let curUser = UserModel(data: document.data())
                    UserDefaults.standard.set(curUser.dictionary, forKey: "CURUSER")
                }
                completion(true)
            }
        })
    }
    
    public func getUsernameByID(id: String) -> String{
        var name = ""
        DatabaseManager.shared.getUserByID(id: id) { result in
            switch result{
            case .success(let user):
                name = user.username
            case .failure(let err):
                print("Get username failed: \(err)")
            }
        }
        return name
    }
    
    public func getUserByID(id: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        let userRef = DatabaseManager.shared.db.collection("user")
        let query = userRef.whereField("uid", isEqualTo: id)
        query.getDocuments(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(.failure(err))
                return
            } else {
                let document = querySnapshot!.documents.first
                guard let doc = document else {
                    completion(.failure(err!))
                    return
                }
                let resUser = UserModel(data: doc.data())
                completion(.success(resUser))
            }
        })
    }
    
    public func getAllUsers(completion: @escaping (Result<[UserModel], Error>) -> Void) {
        var listUsers = [UserModel]()
        let userRef = db.collection("user")
        
        //Get user list
        userRef.addSnapshotListener { (querySnapshot, err) in
            if let error = err {
                print("Error getting documents: \(error)")
                completion(.failure(DatabaseError.failedToFetch))
                return
            } else {
                listUsers = []
                for document in querySnapshot!.documents {
                    listUsers.append(.init(data: document.data()))
                }
                completion(.success(listUsers))
            }
        }
    }
}
//MARK: - Conversation
extension DatabaseManager {
    public func createNewConversation(result: [String: String], completion: @escaping (Bool, String) -> Void) {
        var arrayUser = [String]()
        arrayUser.append(currentID!)

        //Create new Conversation
        let uuid = UUID().uuidString
        if let unwrappedUid = result["uid"]{
            arrayUser.append(unwrappedUid)
            var name = result["username"]!
            if currentID == unwrappedUid {
                name = "self"
            }
            let documentData: [String: Any] = ["id": uuid, "name": name, "users": arrayUser]
            let refConversation = DatabaseManager.shared.db.collection("conversation").document(uuid)
           refConversation.setData(documentData){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                    completion(false, "")
                    return
                } else {
                    print("Conversation successfully written: fields!")
                    print("UID1: \(String(describing: self.currentID)), UID2: \(String(describing: unwrappedUid))")
                    completion(true, uuid)
                }
            }
        }
    }
    
    private func getConversationByID(id: String, completion: @escaping(Result<ConversationModel, Error>) -> Void){
        let conversationRef = DatabaseManager.shared.db.collection("conversation")
        conversationRef.whereField("uid", isEqualTo: id).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting conversation: \(err)")
                completion(.failure(err))
                return
            } else {
                let document = querySnapshot!.documents.first
                guard let doc = document else {
                    completion(.failure(err!))
                    return
                }
                let conversation = ConversationModel(data: doc.data())
                completion(.success(conversation))
            }
        }
    }
    
    public func getAllConversation(completion: @escaping (Result<[ConversationModel], Error>) -> Void){
        var listConversation = [ConversationModel]()
        let conversationRef = db.collection("conversation")
        
        //Get conversation list
        conversationRef.whereField("users", arrayContainsAny: [currentID as Any]).addSnapshotListener { (querySnapshot, err) in
            if let error = err {
                print("Error getting documents: \(error)")
                completion(.failure(DatabaseError.failedToFetch))
                return
            } else {
                listConversation = []
                for document in querySnapshot!.documents{
                    print("Data conversation: \(document.data())")
                    //Get conversation data
                    let temp = ConversationModel(data: document.data())
                    listConversation.append(temp)
                }
                completion(.success(listConversation))
            }
        }
    }
}

//MARK: - Messages

extension DatabaseManager {
    public func createNewMessage(sendMsg: Message, conversationID: String, completion: @escaping(Bool) -> Void){
        let msgRef = db.collection("messages")
        let data = MessageModel(message: sendMsg, conversationID: conversationID)
        msgRef.document(sendMsg.messageId).setData(data.dictionary){ err in
            if let err = err {
                print("Error writing document: \(err)")
                completion(false)
            } else {
                print("Message successfully written!")
                completion(true)
            }
        }
    }
    
    public func getAllMessages(currentConversationID: String, completion: @escaping(Result<[Message], Error>) -> Void){
        var listMessages = [Message]()
        let msgRef = db.collection("messages")
        let query = msgRef.whereField("conversationID", isEqualTo: currentConversationID).order(by: "sentDate")

        //Listen for msg
        query.addSnapshotListener { querySnapshot, err in
            if let err = err{
                print("Error getting messages: \(err)")
                completion(.failure(err))
                return
            }

            querySnapshot!.documentChanges.forEach({ change in
                //Get msg
                if change.type == .added {
                    let resMessage = MessageModel(data: change.document.data())
                    var currKind: MessageKind?
                  
                    if resMessage.kind == "photo"{

                        guard let imageUrl = URL(string: resMessage.content),
                              //TODO: Custom place holder
                              let placeHolder = UIImage(systemName: "photo") else {
                            return
                        }

                        let media = Media(url: imageUrl,
                                          image: nil,
                                          placeholderImage: placeHolder,
                                          size: CGSize(width: 300, height: 300))
                        
                        currKind = .photo(media)
                    }
                    
                    else if resMessage.kind == "video" {
                        // photo
                        guard let videoUrl = URL(string: resMessage.content),
                            let placeHolder = UIImage(named: "video_placeholder") else {
                                return
                        }
                        
                        let media = Media(url: videoUrl,
                                          image: nil,
                                          placeholderImage: placeHolder,
                                          size: CGSize(width: 300, height: 300))
                        print("Video URl: \(videoUrl)")
                        currKind = .video(media)
                    }
                    else if resMessage.kind == "location" {
                        let locationComponents = resMessage.content.components(separatedBy: ",")
                        guard let longitude = Double(locationComponents[0]),
                            let latitude = Double(locationComponents[1]) else {
                            return
                        }
                        print("Rendering location; long=\(longitude) | lat=\(latitude)")
                        let location = Location(location: CLLocation(latitude: latitude, longitude: longitude),
                                                size: CGSize(width: 300, height: 300))
                        currKind = .location(location)
                    }
                    else {
                        currKind = .text(resMessage.content)
                    }
                    
                    //apend
                    guard let finalKind = currKind else{
                        return
                    }
                    let name = self.getUsernameByID(id: resMessage.senderID)
                    
                    var sender = Sender(senderId: resMessage.senderID, displayName: name)
                    
                    //HANDLE nil
                    if(resMessage.id == self.currentID){
                        sender = Sender(senderId: self.currentID ?? "",                     displayName: "self")
                    }
                    
                    listMessages.append(Message(sender: sender,
                                                messageId: resMessage.id,
                                                sentDate: resMessage.sentDate,
                                                kind: finalKind))
                }
            })
            completion(.success(listMessages))
        }
    }
}
//MARK: - Image Cache

class CacheImageView: UIImageView
{

    private let imageCache = NSCache<AnyObject, UIImage>()

    func loadImage(fromURL imageURL: URL)
    {
        self.image = UIImage(systemName: "photo")

        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject)
        {
            debugPrint("image loaded from cache for =\(imageURL)")
            self.image = cachedImage
            return
        }

        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: imageURL)
            {
                debugPrint("image downloaded from server...")
                if let image = UIImage(data: imageData)
                {
                    DispatchQueue.main.async {
                        self!.imageCache.setObject(image, forKey: imageURL as AnyObject)
                        self?.image = image
                    }
                }
            }
        }
    }
}


