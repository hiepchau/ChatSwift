//
//  NewConversationViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 08/12/2022.
//

import UIKit

class NewConversationViewController: BaseViewController {
    //MARK: - Variables
    var viewModel: NewConversationViewModel = NewConversationViewModel()
    var cellDataSources: [NewConversationTableCellViewModel] = []
    public var completionHandler: (([String: Any]) ->Void)?
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users..."
        return searchBar
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = false
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
        setupUI()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        let constraints = [ noResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                            noResultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                            noResultLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2),
                            noResultLabel.heightAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override func setupUI() {
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

    //MARK: - Binding
    
    override func bindViewModel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let strongself = self,
                  let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                isLoading ? strongself.spinner.show(in: strongself.view) :  strongself.spinner.dismiss()
            }
        }
        viewModel.users.bind { [weak self] items in
            guard let strongself = self,
                  let items = items else { return }
            strongself.cellDataSources = items
            strongself.reloadTableView()
        }
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
}

