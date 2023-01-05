//
//  ConversationViewModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 03/01/2023.
//

import Foundation

class ConversationViewModel: BaseViewModel {
    var isLoading: Observable<Bool> = Observable(false)
    var dataSource: [ConversationModel] = []
    var conversations: Observable<[ConversationTableCellViewModel]> = Observable(nil)

    //MARK: - Tableview config
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(in section: Int) -> Int {
        self.dataSource.count
    }
    
    //MARK: - Function
    func logout(){
        FacebookService.shared.logout()
        GoogleService.shared.logout()
        ZaloService.shared.logout()
        
        UserDefaults.standard.set(nil, forKey: Constant.CUR_USER_KEY)
        DatabaseManager.shared.currentID = nil
        print("Logout success, token: \(String(describing: DatabaseManager.shared.currentID))")
    }
    
    func getData() {
        if isLoading.value ?? true {
            return
        }
        
        isLoading.value = true
        
        //Get conversation list
        DatabaseManager.shared.getAllConversation {[weak self] result in
          
            guard let strongself = self else { return }
            strongself.isLoading.value = false
            
            switch result {
            case .success(let dataCollection):
                strongself.dataSource = dataCollection
                strongself.mapCellData()
                print("Success to get conversation")
            case .failure(let error):
                print("Failed to get conversation: \(error)")
            }
        }
    }
    
    private func mapCellData(){
        conversations.value = self.dataSource.compactMap({ConversationTableCellViewModel(conversation: $0)})
    }
    
    
    func retriveConversation(withId id: String) -> ConversationModel? {
        guard let conversation = dataSource.first(where: {$0.id == id}) else {
            return nil
        }
        return conversation
    }
    
    //MARK: - NewConversation handle
    func handleChatViewController(result: [String: String], completion: @escaping (String, String) -> Void){
        if let receivedUid = result["uid"] {
            print("RECEIVEUID: \(receivedUid)")
            checkExists(id: receivedUid, completion: { [weak self] flag, resID, name in
                guard let strongself = self else {return}
                
                if flag {
                    print("Navigate")
                    completion(resID, name)
                } else {
                    print("Create new")
                    strongself.createNewConversation(result: result, completion: { id, name in
                        completion(id, name)
                    })
                }
            })
        }
    }
    
    private func createNewConversation(result: [String: String], completion: @escaping (String, String) -> Void) {
        DatabaseManager.shared.createNewConversation(result: result) { isSuccess, id in
            if isSuccess {
                completion(id, result["name"] ?? "")
                return
            }
            else {
                //TODO: Handle noti
            }
        }
    }
    
    private func checkExists(id: String, completion: @escaping (Bool, String, String) -> Void){
        var flag = false
        var conversationID = ""
        var name = ""
        
        for item in dataSource {
            let arrUser = item.users
            
            print("ARRAY: \(arrUser)")
            if [DatabaseManager.shared.currentID, id] == arrUser {
                flag = true
                conversationID = item.id
                name = item.name
                completion(flag, conversationID, name)
                return
            }
        }
        completion(flag, conversationID, name)
    }
}