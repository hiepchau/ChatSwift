//
//  ChatViewModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 04/01/2023.
//

import Foundation

class ChatViewModel: BaseViewModel {
    
    //MARK: - Variables
    
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
                let currentToken = DatabaseManager.shared.currentID else { return }
        print(text)
        createMessage(sendMssg: Message(id: createMessageID(),
                                        senderID: currentToken,
                                        sentDate: Date(),
                                        kind: .text(text)))
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
