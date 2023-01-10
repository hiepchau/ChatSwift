//
//  ConversationViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 03/01/2023.
//

import UIKit

class ConversationViewController: BaseViewController {

    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ConversationViewModel = ConversationViewModel()
    private var logoutObserver: NSObjectProtocol?
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
        setupUI()
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
    
    override func setupUI() {
        self.title = "Text me"
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        view.addSubview(noConversationsLabel)
        
        ///Observer logout
        logoutObserver = NotificationCenter.default.addObserver(forName: .didLogOutnotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongself = self else {
                return
            }
            strongself.navigationController?.popToRootViewController(animated: true)
        })
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(composeButtonDidTouch))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(logoutButtonDidTouch))
        setupTableView()
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
        viewModel.conversations.bind { [weak self] items in
            guard let strongself = self,
                  let items = items else { return }
            strongself.cellDataSources = items
            strongself.reloadTableView()
        }
    }
    
    @objc private func logoutButtonDidTouch() {
        viewModel.logout()
    }
    
    @objc private func composeButtonDidTouch() {
        //Handle from NewConversationViewController
        let vc = NewConversationViewController()
        vc.completionHandler = { [weak self] result in
            guard let strongself = self else { return }
            
            strongself.viewModel.handleChatViewController(result: result, completion: { (id, name) in
                strongself.navigateToChatView(id: id)
            })
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }

    
    //MARK: - Navigation
    func navigateToChatView(id: String) {
        guard let conversation = viewModel.retriveConversation(withId: id) else { return }
        
        DispatchQueue.main.async {
            let chatViewModel = ChatViewModel(conversation: conversation)
            let vc = ChatViewController(viewModel: chatViewModel)
            vc.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
