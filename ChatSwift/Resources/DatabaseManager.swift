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
    private var isLoggedIn = false
    let db: Firestore

    init(){
        self.db = Firestore.firestore()
    }
    //TODO: Create method get value (user, conversation, message)
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
