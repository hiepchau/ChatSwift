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
    
    private let spinner = JGProgressHUD(style: .dark)
    
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
        view.addSubview(noConversationsLabel)
        setupTableView()
        fecthConversation()
    }
    
    @objc private func didTapComposeButton() {
        let vc = NewConversationViewController()
        vc.completionHandler = { [weak self] result in
            self?.createNewConversation(result: result)
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noConversationsLabel.frame = view.bounds
    }

    //MARK: New conversation
    private func createNewConversation(result: [String: String]) {
        let vc = ChatViewController()
        var arrayUser = [[String: Any]]()
        print(result)
        arrayUser.append(result)
        arrayUser.append(UserDefaults.standard.dictionary(forKey: "CURUSER")!)
        vc.title = result["username"]!
        
        let uuid = UUID().uuidString
        
        if let unwrappedUid = result["uid"]{
            let name = UserDefaults.standard.string(forKey: "loginToken") ?? "Nothing"
            print("UID1: \(name), UID2; \(String(describing: unwrappedUid))")
            //MARK: Add database
            for data in arrayUser {
                DatabaseManage.shared.db.collection("conversation").document(uuid)
                    .collection("users").document(data["uid"] as! String).setData(data){ err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Conversation successfully written!")
                    }
                }
            }

        }

        
        vc.isNewConversation = true
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fecthConversation(){
        tableView.isHidden = false
    }
}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Helo"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = ChatViewController()
        vc.title = "hi"
        vc.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.pushViewController(vc, animated: true)
        print("flag")
    }
}

