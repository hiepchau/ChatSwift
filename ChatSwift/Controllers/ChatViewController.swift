//
//  ChatViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 08/12/2022.
//

import UIKit
import JGProgressHUD



class ChatViewController: UIViewController  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var attachBtn: UIButton!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    

    private let spinner = JGProgressHUD(style: .dark)
    private var messages = [Message]()
    var currentConversationID = ""

    let currentToken = DatabaseManager.shared.currentID
    public var isNewConversation = false
    
//MARK: - LoadView
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        tableView.isHidden = false
        fetchMessage()
        tableView.separatorStyle = .none
        setupChatView() 
    }
    
    private func setupChatView() {
        inputTextView.text = "Aa"
        inputTextView.textColor = UIColor.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputTextView.becomeFirstResponder()
    }

    private func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Media",
                                            message: "What would you like to attach?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoInputActionsheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: { [weak self]  _ in
            self?.presentVideoInputActionsheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }
    
    private func presentPhotoInputActionsheet() {
        let actionSheet = UIAlertController(title: "Attach Photo",
                                            message: "Where would you like to attach a photo from",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)

        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }

    private func presentVideoInputActionsheet() {
        let actionSheet = UIAlertController(title: "Attach Video",
                                            message: "Where would you like to attach a video from?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in

            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            picker.allowsEditing = true
            self?.present(picker, animated: true)

        }))
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { [weak self] _ in

            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            self?.present(picker, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true)
    }
    


//MARK: - Func
    
    @IBAction func didTapSendButton(_ sender: Any) {
        let text = inputTextView.text.replacingOccurrences(of: " ", with: "")
        guard !text.isEmpty, let currentToken = currentToken else { return }
        print(text)
        createMessage(sendMssg: Message(id: createMessageID(),
                                        senderID: currentToken,
                                        sentDate: Date(),
                                        kind: .text(text)))
        inputTextView.text = nil
    }
    
    @IBAction func didTapAttachButton(_ sender: Any) {
        presentInputActionSheet()
    }
    
    private func createMessageID() -> String {
        let uuid = UUID().uuidString
        return uuid
    }
    //Write to database
    private func createMessage(sendMssg: Message)  {
        guard !currentConversationID.isEmpty else {
            print("Error: Don't match any conversation")
            return
        }
        DatabaseManager.shared.createNewMessage(sendMsg: sendMssg, conversationID: currentConversationID) { isSucess in
            if isSucess {
                print("Message successfully written!")
            } else {
                //TODO: Display error noti
            }
        }
    }
    
        private func fetchMessage() {
        print("Current conversation ID: \(currentConversationID)")
        
        DatabaseManager.shared.getAllMessages(currentConversationID: currentConversationID, completion: {[weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let messageCollection):
                strongSelf.messages = messageCollection
                print("Fetch successful!, \(strongSelf.messages.count)")
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                    strongSelf.tableView.scrollToBottom()
                }
            case .failure(let error):
                print("Failed to get conversation: \(error)")
            }
        })
    }
}


// MARK: - Extension

extension ChatViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ chatView: UITextView) {
        if chatView.textColor == UIColor.lightGray {
            chatView.text = nil
            chatView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ chatView: UITextView) {
        if chatView.text.isEmpty {
            chatView.text = "Placeholder"
            chatView.textColor = UIColor.lightGray
        }
    }
}


extension ChatViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return messages.count
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let textCell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! ChatMessageCell
        let imgCell = tableView.dequeueReusableCell(withIdentifier: "imgCell", for: indexPath) as! MediaMessageCell

//        let item = messages[indexPath.section][indexPath.row]
        let item = messages[indexPath.row]

                
        let isSender = (item.senderID == currentToken)

        switch item.kind {
        case .text(let textMsg):
            textCell.msglabel.text = textMsg
            textCell.setupUI(isSender: isSender)
            textCell.selectionStyle = .none;
            return textCell
        case .photo(let url):
//            imgCell.imageMsg.image = img.resizeWithScaleAspectFitMode(to: CGFloat(300))
            imgCell.setupUI(isSender: isSender)
            imgCell.imageMsg.loadImage(fromURL: url)
            imgCell.selectionStyle = .none;
            return imgCell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
            if indexPath.row == lastRowIndex - 1 {
                tableView.scrollToBottom(animated: false)
            }
        }
}

class DateHeaderLabel: UILabel {

    override var intrinsicContentSize: CGSize{
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + 12
        layer.cornerRadius = height / 2
        layer.masksToBounds = true
        return CGSize(width: originalContentSize.width + 16, height: height)
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let messageId = createMessageID()
        
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
                          let currentToken = strongSelf.currentToken else {
                            return
                    }
                    
                    let message = Message(id: messageId,
                                          senderID: currentToken,
                                          sentDate: Date(),
                                          kind: .photo(url))
                    strongSelf.createMessage(sendMssg: message)

                case .failure(let error):
                    print("message photo upload error: \(error)")
                }
            })
        }
    }
}


