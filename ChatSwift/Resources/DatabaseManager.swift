//
//  DatabaseManager.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 09/12/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class DatabaseManage {
    static let shared = DatabaseManage()
    private var isLoggedIn = false
    let db: Firestore
    
    init(){
        self.db = Firestore.firestore()
    }
    
    public func authenticate(username: String?, password: String?) -> Bool?{
        let userRef = db.collection("users")
        // Create a query against the collection.
        let query = userRef.whereField("username", isEqualTo: username!)
            .whereField("password", isEqualTo: password!)
        query.getDocuments(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    print("ID: \(document.documentID) => Data \(document.data())")
                    self.isLoggedIn = true
                }
            }
        })
        return isLoggedIn
    }
    
//    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void){
//        db.collection("users").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                completion(querySnapshot!.documents)
//            }
//        }
//    }
}
