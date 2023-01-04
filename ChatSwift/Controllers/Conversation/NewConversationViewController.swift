//
//  NewConversationViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 08/12/2022.
//

import UIKit
import FirebaseFirestore
import JGProgressHUD

class NewConversationViewController: UIViewController {

    //MARK: - Variables
    
    var viewModel: NewConversationViewModel = NewConversationViewModel()
    private let spinner = JGProgressHUD(style: .dark)
    var cellDataSources: [NewConversationTableCellViewModel] = []
    
    public var completionHandler: (([String: String]) ->Void)?
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users..."
        return searchBar
    }()
    
    let tableView: UITableView = {
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
    
    
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noResultLabel)
        view.addSubview(tableView)
        
        setupTableView()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissSelf))

        searchBar.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultLabel.frame = CGRect(x: view.width / 4 ,
                                 y: (view.height - 200)/2,
                                 width: view.width / 2,
                                 height: 200)
    }
    

    
    //MARK: - Binding
    
    func bindViewModel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let strongself = self,
                  let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                isLoading ? strongself.spinner.show(in: strongself.view) :  strongself.spinner.dismiss()
            }
        }
        viewModel.users.bind { [weak self] movies in
            guard let strongself = self,
                  let movies = movies else { return }
            strongself.cellDataSources = movies
            strongself.reloadTableView()
        }
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
}

