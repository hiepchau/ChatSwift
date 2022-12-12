//
//  NewConversationViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 08/12/2022.
//

import UIKit
import FirebaseFirestore

class NewConversationViewController: UIViewController {

    var users = [UserModel]()
    let db = Firestore.firestore()
    
    public var completionHandler: (([String: String]) ->Void)?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users..."
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No result"
        label.textAlignment = .center
        label.textColor = .green
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    
    // MARK: - Load view
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noResultLabel)
        view.addSubview(tableView)
        
        fetchUsersData()
        
        setupTableView()
        searchBar.delegate = self
        
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissSelf))

        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultLabel.frame = CGRect(x: view.bounds.width / 4 ,
                                 y: (view.bounds.height - 200)/2,
                                 width: view.bounds.width / 2,
                                 height: 200)
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
    //MARK: DB
    private func fetchUsersData(){
        db.collection("user").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.users.append(.init(data: document.data()))
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("Fetch success")
            }
        }
        
    }
}
//MARK: - Extension

//TODO: search querry func
extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].username
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetUserData = users[indexPath.row]
        
        dismiss(animated: true, completion: { [weak self] in
            self?.completionHandler?(targetUserData.dictionary)
        })

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
    }
}
