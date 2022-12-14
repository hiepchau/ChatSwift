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
import SDWebImage
import AVFoundation
import AVKit
import CoreLocation
import SwiftUI

class ChatViewController: MessagesViewController {

    private let spinner = JGProgressHUD(style: .dark)
    
    private var messages = [Message]()
    var currentCountCell = -1
    var currentConversationID = ""
    var currentConversation = ConversationModel()
    static let currentToken = UserDefaults.standard.string(forKey: "LOGINTOKEN")
    public let selfSender = Sender(senderId: currentToken!, displayName: "self")
    public var isNewConversation = false
    
//MARK: - LoadView
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
        view.backgroundColor = .blue
        getConversationData()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
        setupInputButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMessage(shouldScrollToBottom: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    private func setupInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.onTouchUpInside { [self] _ in
            self.presentInputActionSheet()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    
    private func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Media",
                                            message: "What would you like to attach?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [self] _ in
            self.presentPhotoInputActionsheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: { [self]  _ in
            self.presentVideoInputActionsheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Audio", style: .default, handler: {  _ in

        }))
        actionSheet.addAction(UIAlertAction(title: "Location", style: .default, handler: { [self]  _ in
            self.presentLocationPicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }
    
    private func presentLocationPicker() {
        let vc = LocationPickerViewController(coordinates: nil)
        vc.title = "Pick Location"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { [weak self] selectedCoorindates in

            guard let strongSelf = self else {
                return
            }
            let messageId = strongSelf.createMessageID()

            let selfSender = strongSelf.selfSender

            let longitude: Double = selectedCoorindates.longitude
            let latitude: Double = selectedCoorindates.latitude

            print("long=\(longitude) | lat= \(latitude)")


            let location = Location(location: CLLocation(latitude: latitude, longitude: longitude),
                                 size: .zero)

            let message = Message(sender: selfSender,
                                  messageId: messageId,
                                  sentDate: Date(),
                                  kind: .location(location))

            strongSelf.createMessage(sendMssg: message)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    private func presentPhotoInputActionsheet() {
        let actionSheet = UIAlertController(title: "Attach Photo",
                                            message: "Where would you like to attach a photo from",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [self] _ in

            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true)

        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [self] _ in

            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true)

        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }

    private func presentVideoInputActionsheet() {
        let actionSheet = UIAlertController(title: "Attach Video",
                                            message: "Where would you like to attach a video from?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [self] _ in

            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            picker.allowsEditing = true
            self.present(picker, animated: true)

        }))
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { [self] _ in

            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            self.present(picker, animated: true)

        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }
    //MARK: - Func
    
    private func fetchMessage(shouldScrollToBottom: Bool) {
        let messagesRef = DatabaseManager.shared.db.collection("messages")
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
                    self.messagesCollectionView.scrollToLastItem(animated: false)
                }
            }
        }
    }
    
    private func GetImageFromURL(url: URL, row: Int) {
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            let media = Media(url: url,
                              image: UIImage(data: data),
                              placeholderImage: UIImage(systemName: "photo")!,
                              size: CGSize(width: 300, height: 300))
        
            let indexPath = IndexPath(row: row, section: 0)
            self.messages[row].kind = .photo(media)

            DispatchQueue.main.async {
                self.messagesCollectionView.reloadItems(at: [indexPath])
            }
        }
    }

    private func appendMessage(mssg: MessageModel) {
        print("Append executed")
        currentCountCell += 1
        var currKind: MessageKind?
      
        if mssg.kind == "photo"{

            guard let imageUrl = URL(string: mssg.content),
                  //TODO: Custom place holder
                  let placeHolder = UIImage(systemName: "photo") else {
                return
            }
            
            DispatchQueue.global().async {
                self.GetImageFromURL(url: imageUrl, row: self.currentCountCell)
            }

            let media = Media(url: imageUrl,
                              image: nil,
                              placeholderImage: placeHolder,
                              size: CGSize(width: 300, height: 300))
            
            print("Image URl: \(imageUrl)")
            currKind = .photo(media)
        }
        
        else if mssg.kind == "video" {
            // photo
            guard let videoUrl = URL(string: mssg.content),
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
        else if mssg.kind == "location" {
            let locationComponents = mssg.content.components(separatedBy: ",")
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
            currKind = .text(mssg.content)
        }
        
        //apend
        guard let finalKind = currKind else{
            return
        }

            // update UI
            var sender = Sender(senderId: mssg.senderID, displayName: self.getUsernameByID(id: mssg.id))
            
            if(mssg.id == ChatViewController.currentToken){
                sender = self.selfSender
            }
            self.messages.append(Message(sender: sender,
                                    messageId: mssg.id,
                                    sentDate: mssg.sentDate,
                                    kind: finalKind))
        
            print("Count message: \(self.messages.count)")
        
        

    }
    
    //Send to database
    private func createMessage(sendMssg: Message)  {
        guard currentConversationID != "" else {
            print("Error: Empty conversation ID")
            return
        }

        let data = MessageModel(message: sendMssg, conversationID: currentConversationID)
        DatabaseManager.shared.db.collection("messages").document(sendMssg.messageId).setData(data.dictionary){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Message successfully written!")
            }
        }
    }
    private func getUsernameByID(id: String) -> String{
        var result = ""
        let userRef = DatabaseManager.shared.db.collection("user")
        
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
    
    private func getConversationData(){
        let conversationRef = DatabaseManager.shared.db.collection("conversation")
        conversationRef.whereField("uid", isEqualTo: currentConversationID).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.currentConversation =  ConversationModel(data: document.data())
                }
            }
        }
    }
    
}


// MARK: - Extension

//TODO: Custom cell
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: "", with: "").isEmpty else{
            return
        }
       
        let mssgID = createMessageID()
        DispatchQueue.main.async {
            let sendMssg = Message(sender: self.selfSender,
                                   messageId: mssgID,
                                   sentDate: Date(),
                                   kind: .text(text))
            //Insert db
            self.createMessage(sendMssg: sendMssg)
            
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
    
    private func createMessageID() -> String {
        let uuid = UUID().uuidString
        return uuid
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let messageId = createMessageID()
        let selfSender = selfSender
        

        if let image = info[.editedImage] as? UIImage, let imageData =  image.pngData() {
            let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".png"

            // Upload image

            StorageManager.shared.uploadMessagePhoto(with: imageData, fileName: fileName, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }

                switch result {
                case .success(let urlString):
                    // Ready to send message
                    print("Uploaded Message Photo: \(urlString)")

                    guard let url = URL(string: urlString),
                        let placeholder = UIImage(systemName: "plus") else {
                            return
                    }

                    let media = Media(url: url,
                                      image: nil,
                                      placeholderImage: placeholder,
                                      size: .zero)

                    let message = Message(sender: selfSender,
                                          messageId: messageId,
                                          sentDate: Date(),
                                          kind: .photo(media))

                    strongSelf.createMessage(sendMssg: message)

                case .failure(let error):
                    print("message photo upload error: \(error)")
                }
            })
        }
        else if let videoUrl = info[.mediaURL] as? URL {
            let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".mov"

            // Upload Video

            StorageManager.shared.uploadMessageVideo(with: videoUrl, fileName: fileName, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }

                switch result {
                case .success(let urlString):
                    // Ready to send message
                    print("Uploaded Message Video: \(urlString)")

                    guard let url = URL(string: urlString),
                        let placeholder = UIImage(systemName: "plus") else {
                            return
                    }

                    let media = Media(url: url,
                                      image: nil,
                                      placeholderImage: placeholder,
                                      size: .zero)

                    let message = Message(sender: selfSender,
                                          messageId: messageId,
                                          sentDate: Date(),
                                          kind: .video(media))

                    strongSelf.createMessage(sendMssg: message)

                case .failure(let error):
                    print("message photo upload error: \(error)")
                }
            })
        }
    }
    
}

extension ChatViewController: MessageCellDelegate {
    func didTapMessage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }

        let message = messages[indexPath.section]

        switch message.kind {
        case .location(let locationData):
            let coordinates = locationData.location.coordinate
            let vc = LocationPickerViewController(coordinates: coordinates)
            
            vc.title = "Location"
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }

    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }

        let message = messages[indexPath.section]

        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            let vc = PhotoViewerViewController(with: imageUrl)
            navigationController?.pushViewController(vc, animated: true)
        case .video(let media):
            guard let videoUrl = media.url else {
                return
            }

            let vc = AVPlayerViewController()
            vc.player = AVPlayer(url: videoUrl)
            present(vc, animated: true)
        default:
            break
        }
    }
}

