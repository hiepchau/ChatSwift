//
//  ConversationsViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 08/12/2022.
//

import UIKit
import JGProgressHUD

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
        label.isHidden = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
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
//        let nav = UINavigationController(rootViewController: vc)
//        nav.pushViewController(vc, animated: true)
//        present(nav, animated: true)
        vc.title = "hi"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
