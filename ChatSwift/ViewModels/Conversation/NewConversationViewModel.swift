//
//  NewConversationViewModel.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 04/01/2023.
//

import Foundation

class NewConversationViewModel: BaseViewModel {
    
    var isLoading: Observable<Bool> = Observable(false)
    var dataSource: [UserModel] = []
    var users: Observable<[NewConversationTableCellViewModel]> = Observable(nil)

    //MARK: - Tableview config
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(in section: Int) -> Int {
        self.dataSource.count
    }
    
    //MARK: - Function
    func getData(){
        if isLoading.value ?? true {
            return
        }
        isLoading.value = true
        //Get user list
        DatabaseManager.shared.getAllUsers {[weak self] result in
            guard let strongself = self else { return }
            strongself.isLoading.value = false
            switch result {
            case.success(let userCollection):
                strongself.dataSource = userCollection
                strongself.mapCellData()
                print("Get users data susccess, Count: \(strongself.dataSource.count)")
            case.failure(let error):
                print("Failed to get users: \(error)")
            }
        }
    }
    
    func retriveUser(withId id: String) -> UserModel? {
        guard let user = dataSource.first(where: {$0.id == id}) else {
            return nil
        }
        return user
    }
    
    private func mapCellData(){
        users.value = self.dataSource.compactMap({NewConversationTableCellViewModel(user: $0)})
    }
}
