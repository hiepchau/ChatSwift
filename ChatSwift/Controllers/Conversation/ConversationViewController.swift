//
//  ConversationViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 03/01/2023.
//

import UIKit
import JGProgressHUD
class ConversationViewController: UIViewController {

    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    private let spinner = JGProgressHUD(style: .dark)
    
    var viewModel: ConversationViewModel = ConversationViewModel()
    
    var cellDataSources: [ConversationTableCellViewModel] = []
   
    private let noConversationsLabel: UILabel = {
       let label = UILabel()
        label.text = "Hi"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(composeButtonDidTouch))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .redo,
                                                           target: self, action:
                                                            #selector(logoutButtonDidTouch))
        configView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.getData()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noConversationsLabel.frame = view.bounds
    }
    
    func configView() {
        self.title = "Text me"
        self.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(noConversationsLabel)
        setupTableView()
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
        viewModel.conversations.bind { [weak self] movies in
            guard let strongself = self,
                  let movies = movies else { return }
            strongself.cellDataSources = movies
            strongself.reloadTableView()
        }
    }
    
    @objc private func logoutButtonDidTouch() {
        viewModel.logout()
        self.dismiss(animated: true)
    }
    
    @objc private func composeButtonDidTouch() {
        //Handle from NewConversationViewController
        let vc = NewConversationViewController()
        vc.completionHandler = { [weak self] result in
            guard let strongself = self else { return }
            
            strongself.viewModel.handleChatViewController(result: result, completion: { (id, name) in
                strongself.navigateToChatView(id: id, name: name)
            })
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }

    
    //MARK: - Navigation
    func navigateToChatView(id: String, name: String) {
        let vc = ChatViewController()
        vc.isNewConversation = false
        vc.currentConversationID = id
        vc.title = name
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
