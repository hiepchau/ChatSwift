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
    
    private let floatingButton: UIButton = {
        let floatingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        floatingButton.layer.masksToBounds = true
        floatingButton.backgroundColor = .blue
        floatingButton.layer.cornerRadius = 30
//        floatingButton.backgroundColor = .systemPink
        let image = UIImage(systemName: "plus",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        floatingButton.setImage(image, for: .normal)
        floatingButton.setTitleColor(.white, for: .normal)
        floatingButton.tintColor = .white
        return floatingButton
    }()
    
    private let spinner = JGProgressHUD(style: .dark)
    let curID = UserDefaults.standard.string(forKey: "LOGINTOKEN")


    var listConversation = [ConversationModel]()
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noConversationsLabel: UILabel = {
       let label = UILabel()
        label.text = "hi"
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
        view.addSubview(tableView)
//        view.addSubview(floatingButton)
        view.addSubview(noConversationsLabel)
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fecthConversation(){
            print("Fetch conversation success")
        }
    }
    
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
    
    //New conversation
    private func createNewConversation(result: [String: String]) {
        var arrayUser = [String]()
        arrayUser.append(curID!)

        //Create new Conversation
        let uuid = UUID().uuidString
        if let unwrappedUid = result["uid"]{
            arrayUser.append(unwrappedUid)
            var name = result["username"]!
            if curID == unwrappedUid {
                name = "self"
            }
            let documentData: [String: Any] = ["id": uuid, "name": name, "users": arrayUser]
            let refConversation = DatabaseManager.shared.db.collection("conversation").document(uuid)
           refConversation.setData(documentData){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                    //TODO: handle
                    return
                } else {
                    print("Conversation successfully written: fields!")
                }
            }
            print("UID1: \(String(describing: curID)), UID2: \(String(describing: unwrappedUid))")
        }
        navigateToChatView(id: uuid, name: result["username"]!)
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
//        var tempID: String?
//        if id == curID {
//
//        }

        for item in listConversation {
            let arrUser = item.users
            
            print("ARRAY: \(arrUser)")
            if [curID!, id] == arrUser {
                flag = true
                conversationID = item.id
                name = item.name
                completion(flag, conversationID, name)
                return
            }
        }
        completion(flag, conversationID, name)
    }
    //fetch Conversation
    private func fecthConversation(completion: @escaping () -> Void){
        listConversation = []
        tableView.isHidden = false
        spinner.show(in: view)
        let conversationRef = DatabaseManager.shared.db.collection("conversation")
        
        //Get conversation list
        conversationRef.whereField("users", arrayContainsAny: [curID!]).getDocuments { [self](querySnapshot, err) in
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            if let err = err {
                print("Error getting documents: \(err)")
                completion()
                return
            } else {
                for document in querySnapshot!.documents{
                    print("Data conversation: \(document.data())")
                    //Get conversation data
                    let temp = ConversationModel(data: document.data())
                    listConversation.append(temp)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                completion()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = listConversation[indexPath.row].name
        return cell
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



