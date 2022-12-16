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
        let userRef = db.collection("users")
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
    public func getAllConversation(completion: @escaping (Result<[ConversationModel], Error>) -> Void){
        var listConversation = [ConversationModel]()
        let conversationRef = db.collection("conversation")
        
        //Get conversation list
        conversationRef.whereField("users", arrayContainsAny: [currentID!]).addSnapshotListener { (querySnapshot, err) in
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
}

//MARK: - Messages






class ImageCache
{
    static let shared = ImageCache()
    private let imageCache = NSCache<AnyObject, UIImage>()
    
    func loadImage(fromURL imageURL: URL) -> UIImage
    {
        var image = UIImage(systemName: "photo")!

        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject)
        {
            debugPrint("image loaded from cache for =\(imageURL)")
            image = cachedImage
            return image
        }

        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: imageURL)
            {
                debugPrint("image downloaded from server...")
                if let imageTemp = UIImage(data: imageData)
                {
                    DispatchQueue.main.async {
                        self!.imageCache.setObject(image, forKey: imageURL as AnyObject)
                        image = imageTemp
                    }
                }
            }
        }
        return image
    }
}


