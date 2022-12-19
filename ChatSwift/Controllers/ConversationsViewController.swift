//
//  ConversationsViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 08/12/2022.
//

import UIKit
import JGProgressHUD
import FirebaseFirestore
class ConversationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let spinner = JGProgressHUD(style: .dark)
    let curID = DatabaseManager.shared.currentID


    var listConversation = [ConversationModel]()
    
    private let noConversationsLabel: UILabel = {
       let label = UILabel()
        label.text = "Hi"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
//MARK: - Load view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(didTapComposeButton))
        fecthConversation()
        view.addSubview(noConversationsLabel)
        setupTableView()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.tableView.estimatedRowHeight = 120
//        self.tableView.rowHeight = UITableView.automaticDimension
//    }
//
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noConversationsLabel.frame = view.bounds
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
//MARK: - Function
    
    @objc private func didTapComposeButton() {
        //Handle from NewConversationViewController
        let vc = NewConversationViewController()
        vc.completionHandler = { [weak self] result in
            self?.handleChatViewController(result: result)
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }

    //Check exsists conversation
    private func handleChatViewController(result: [String: String]){
        if let receivedUid = result["uid"] {
            print("RECEIVEUID: \(receivedUid)")
            checkExists(id: receivedUid, completion: { [self] flag, resID, name in
                if flag {
                    print("Navigate: \(flag)")
                    navigateToChatView(id: resID, name: name)
                } else {
                    print("Create new")
                    createNewConversation(result: result)
                }
            })
        }
        
    }
    
    private func navigateToChatView(id: String, name: String){
        let vc = ChatViewController()
        vc.isNewConversation = false
        vc.currentConversationID = id
        vc.title = name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func checkExists(id: String, completion: @escaping (Bool, String, String) -> Void){
        var flag = false
        var conversationID = ""
        var name = ""

        for item in listConversation {
            let arrUser = item.users
            
            print("ARRAY: \(arrUser)")
            if [curID, id] == arrUser {
                flag = true
                conversationID = item.id
                name = item.name
                completion(flag, conversationID, name)
                return
            }
        }
        completion(flag, conversationID, name)
    }
    
    //New conversation
    private func createNewConversation(result: [String: String]) {
        DatabaseManager.shared.createNewConversation(result: result) { isSuccess, uuid in
            if isSuccess {
                self.navigateToChatView(id: uuid, name: result["username"] ?? "")
            }
            else {
                //TODO: Handle noti
            }
        }
    }
    
    //Fetch Conversation
    private func fecthConversation(){
        
        self.listConversation = []
        tableView.isHidden = false
        spinner.show(in: view)
        
        //Get conversation list
        DatabaseManager.shared.getAllConversation {[weak self] result in
          
            guard let strongself = self else { return }
            
            DispatchQueue.main.async {
                strongself.spinner.dismiss()
            }
            
            switch result {
            case .success(let dataCollection):
                strongself.listConversation = dataCollection
                
                if strongself.listConversation.isEmpty {
                    strongself.tableView.isHidden = true
                    strongself.noConversationsLabel.isHidden = false
                    return
                }
                DispatchQueue.main.async {
                    strongself.tableView.reloadData()
                }
            case .failure(let error):
                strongself.tableView.isHidden = true
                strongself.noConversationsLabel.isHidden = false
                print("Failed to get conversation: \(error)")
            }
        }
    }
    
}

//MARK: - Extension

//TODO: Custom cell
extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listConversation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = listConversation[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier,
                                                 for: indexPath) as! ConversationTableViewCell
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0;
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = ChatViewController()
        vc.currentConversationID = listConversation[indexPath.row].id
        vc.title = listConversation[indexPath.row].name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}



