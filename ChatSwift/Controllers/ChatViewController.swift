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

    private let spinner = JGProgressHUD(style: .dark)
    
    private var testMssg = [Message]()
    var currentConversationID = ""
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

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMessage(shouldScrollToBottom: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    //MARK: - Func
    
    private func fetchMessage(shouldScrollToBottom: Bool) {
        let messagesRef = DatabaseManage.shared.db.collection("messages")
        print("Current conversation ID: \(currentConversationID)")
        let query = messagesRef.whereField("conversationID", isEqualTo: currentConversationID).order(by: "sentDate")
        spinner.show(in: view)
        query.addSnapshotListener { [self] querySnapshot, err in
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            if let err = err{
                print("Error getting messages: \(err)")
                return
            }
            querySnapshot!.documentChanges.forEach({ change in
                //Apend to mssg List
                if change.type == .added{
                    let resMessage = MessageModel(data: change.document.data())
                    appendMessage(mssg: resMessage)
                }

            })
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadDataAndKeepOffset()
                if shouldScrollToBottom{
                    self.messagesCollectionView.scrollToLastItem()
                }
            }
        }
    }
    
    private func appendMessage(mssg: MessageModel) {
        print("Append executed")
        var sender = Sender(senderId: mssg.senderID, displayName: getUsernameByID(id: mssg.id))
        if(mssg.id == ChatViewController.currentToken){
            sender = selfSender
        }
        testMssg.append(Message(sender: sender,
                                messageId: mssg.id,
                                sentDate: mssg.sentDate,
                                kind: .text(mssg.text)))
        print("Count message: \(self.testMssg.count)")
    }
    
    private func createMessage(sendMssg: Message, text: String)  {
        guard currentConversationID != "" else {
            print("Error: Empty conversation ID")
            return
        }

        let data = MessageModel(message: sendMssg, conversationID: currentConversationID, text: text)
        DatabaseManage.shared.db.collection("messages").document(sendMssg.messageId).setData(data.dictionary){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Message successfully written!")
            }
        }
    }
    private func getUsernameByID(id: String) -> String{
        var result = ""
        let userRef = DatabaseManage.shared.db.collection("user")
        
        // Create a query against the collection.
        let query = userRef.whereField("uid", isEqualTo: id)
        query.getDocuments(completion: { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let resUser = UserModel(data: document.data())
                    result = resUser.username
                }
            }
        })
        return result
    }
}


// MARK: - Extension

//TODO: Custom cell
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

       
        let uuid = UUID().uuidString
        DispatchQueue.main.async {
            let sendMssg = Message(sender: self.selfSender,
                                   messageId: uuid,
                                   sentDate: Date(),
                                   kind: .text(text))
            //Insert db
            self.createMessage(sendMssg: sendMssg, text: text)
            
            self.messageInputBar.inputTextView.text = nil
        }

        print("Sending mssg: \(text)")
        //Send message
        if isNewConversation{
            
        }
        else {
            // append to existing data
        }
        
    }
}
