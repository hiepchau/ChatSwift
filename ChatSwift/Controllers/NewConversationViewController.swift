//
//  NewConversationViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 08/12/2022.
//

import UIKit
import FirebaseFirestore

class NewConversationViewController: UIViewController {

    var usersList = [UserModel]()
    
    public var completionHandler: (([String: String]) ->Void)?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users..."
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No body here..."
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
        noResultLabel.frame = CGRect(x: view.width / 4 ,
                                 y: (view.height - 200)/2,
                                 width: view.width / 2,
                                 height: 200)
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
    
//MARK: - Func
    private func fetchUsersData(){
        self.usersList = []
        tableView.isHidden = false
        DatabaseManager.shared.getAllUsers { result in
            switch result {
            case.success(let userCollection):
                self.usersList = userCollection
                if self.usersList.isEmpty {
                    self.tableView.isHidden = true
                    self.noResultLabel.isHidden = false
                    return
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case.failure(let error):
                self.tableView.isHidden = true
                self.noResultLabel.isHidden = false
                print("Failed to get users: \(error)")
            }
            
        }
    }
}

//MARK: - Extension

//TODO: search querry func
extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = usersList[indexPath.row].username
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetUserData = usersList[indexPath.row]
        
        dismiss(animated: true, completion: { [weak self] in
            self?.completionHandler?(targetUserData.dictionary)
        })

    }
    //TODO: search handle
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
    }
}
