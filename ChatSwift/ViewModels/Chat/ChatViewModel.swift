//
//  ChatViewModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 04/01/2023.
//

import Foundation

class ChatViewModel: BaseViewModel {
    
    //MARK: - Variables
    
    let currentToken = DatabaseManager.shared.currentID
    
    var currentConversationID: String = ""
    var currentConversationName: String = ""
    
    var textViewInput: Observable<String> = Observable("")
    
    var isLoading: Observable<Bool> = Observable(false)
    var dataSource: [Message] = []
    var messages: Observable<[ChatTableCellViewModel]> = Observable(nil)

    //Init
    init(conversation: ConversationModel){
        self.currentConversationID = conversation.conversationID
        self.currentConversationName = conversation.name
    }
    
    //MARK: - Tableview config
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(in section: Int) -> Int {
        self.dataSource.count
    }
    
    //MARK: - Function
    
    //Observe msg
    func observeTextChange(text: String?) {
        self.textViewInput.value = text ?? ""
    }
    
    //Create id
    private func createMessageID() -> String {
        let uuid = UUID().uuidString
        return uuid
    }
    
    //Send msg
    func sendMesage(){
        guard let text = textViewInput.value,
                !text.replacingOccurrences(of: " ", with: "").isEmpty,
                let currentToken = currentToken else { return }
        print(text)
        createMessage(sendMssg: Message(id: createMessageID(),
                                        senderID: currentToken,
                                        sentDate: Date(),
                                        kind: .text(text)))
    }
    
    func createImageMessage(imageData: Data) {
        let messageId = createMessageID()
        let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".png"
        
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
    
    //Create msg in database
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
    
    
    func getData() {
        if isLoading.value ?? true {
            return
        }
        
        isLoading.value = true
        
        //Get conversation list
        DatabaseManager.shared.getAllMessages(currentConversationID: currentConversationID, completion: {[weak self] result in
          
            guard let strongself = self else { return }
            strongself.isLoading.value = false
            
            switch result {
            case .success(let messageCollection):
                strongself.dataSource = messageCollection
                strongself.mapCellData()
                print("Fetch successful!, \(strongself.dataSource.count)")
            case .failure(let error):
                print("Failed to get conversation: \(error)")
            }
        })
    }
                                              
    private func mapCellData(){
        messages.value = self.dataSource.compactMap({ChatTableCellViewModel(message: $0)})
    }
    
    
//    func retriveConversation(withId id: String) -> ConversationModel? {
//        guard let conversation = dataSource.first(where: {$0.id == id}) else {
//            return nil
//        }
//        return conversation
//    }
    
    
}
