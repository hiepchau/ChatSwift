//
//  ChatViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 08/12/2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import CloudKit
import JGProgressHUD

class ChatViewController: MessagesViewController {

    private var listMssgsModel = [MessageModel]()
    private let spinner = JGProgressHUD(style: .dark)
    
    private var testMssg = [Message]()
    static let currentToken = UserDefaults.standard.string(forKey: "LOGINTOKEN")
    public let selfSender = Sender(senderId: currentToken!, displayName: "self")
    public var isNewConversation = false
    public let anotherSender = Sender(senderId: "2", displayName: "who")
    public let another1Sender = Sender(senderId: "2", displayName: "whoa")

    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .blue
        //TODO: Get conversation ID, Messages list, push mssg to db,
        testMssg.append(Message(sender: anotherSender,
                                messageId: "3",
                                sentDate: Date(),
                                kind: .text("receive message")))
        testMssg.append(Message(sender: anotherSender,
                                messageId: "3",
                                sentDate: Date(),
                                kind: .text("receive message1")))
        testMssg.append(Message(sender: selfSender,
                                messageId: "4",
                                sentDate: Date(),
                                kind: .text("First message")))
        testMssg.append(Message(sender: selfSender,
                                messageId: "4",
                                sentDate: Date(),
                                kind: .text("First message1")))

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMessages()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    //MARK: - Func
    
    private func fetchMessages(){
        spinner.show(in: view)
        for mssg in listMssgsModel{
            var sender = Sender(senderId: mssg.senderID, displayName: getUsernameByID(id: mssg.id))
            if(mssg.id == ChatViewController.currentToken){
                sender = selfSender
            }
            testMssg.append(Message(sender: sender,
                                    messageId: mssg.id,
                                    sentDate: mssg.sentDate,
                                    kind: .text(mssg.text)))
        }
        DispatchQueue.main.async {
            self.spinner.dismiss()
        }
    }
    
    private func addMessage(sendMssg: Message, text: String){
        let data = MessageModel(message: sendMssg, conversationID: "String", text: text)
        let refMessage = DatabaseManage.shared.db.collection("messages").document(sendMssg.messageId).setData(data.dictionary){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Conversation successfully written!")
            }
        }
    }
    
    private func getUsernameByID(id: String) -> String{
        var username = ""
        let userRef = DatabaseManage.shared.db.collection("user")
        
        // Create a query against the collection.
        let query = userRef.whereField("uid", isEqualTo: id)
        query.getDocuments(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let resUser = UserModel(data: document.data())
                    username = resUser.username
                }
            }
        })
        return username
    }
}


// MARK: - Extension
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return testMssg[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return testMssg.count
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: "", with: "").isEmpty else{
            return
        }

        //TODO: Push mssg to db
       
//        let documentData: [String: Any] = ["id": uuid, "name": result["username"]!]
        
//
//        let cur = UserDefaults.standard.string(forKey: "loginToken") ?? "Nothing"
//        print("UID1: \(cur), UID2: \(String(describing: unwrappedUid))")
//        //MARK: Add database
//        for data in arrayUser {
//            refConversation.collection("users").document(data["uid"] as! String).setData(data){ err in
//                if let err = err {
//                    print("Error writing document: \(err)")
//                } else {
//                    print("Conversation successfully written!")
//                }
//            }
//        }
        let uuid = UUID().uuidString
        DispatchQueue.main.async {
            let sendMssg = Message(sender: self.selfSender,
                                   messageId: uuid,
                                   sentDate: Date(),
                                   kind: .text(text))
            self.testMssg.append(sendMssg)
            //Insert db
            self.addMessage(sendMssg: sendMssg, text: text)
            
            self.messageInputBar.inputTextView.text = nil
            self.messagesCollectionView.reloadData()
        }

        print("Sendinng mssg: \(text)")
        //Send message
        if isNewConversation{
            
        }
        else {
            // append to existing data
        }
        
    }
}
