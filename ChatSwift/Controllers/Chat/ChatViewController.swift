//
//  ChatViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 04/01/2023.
//

import UIKit

class ChatViewController: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextView: UITextView!
    
    var viewModel: ChatViewModel
    var cellDataSources: [ChatTableCellViewModel] = []
    
    init(viewModel: ChatViewModel){
        self.viewModel = viewModel
        super.init(nibName: "ChatViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputTextView.becomeFirstResponder()
        viewModel.getData()
    }
    
    override func setupUI() {
        self.title = viewModel.currentConversationName
        inputTextView.delegate = self
        setupTableView()
        print("Current chat room ID: \(viewModel.currentConversationID)")
    }
    
    //MARK: - IBActions
    @IBAction func sendButtonDidTouch(_ sender: UIButton) {
        viewModel.sendMesage()
        inputTextView.text = nil
    }

    @IBAction func didTapAttachButton(_ sender: Any) {
        presentInputActionSheet()
    }
    
    //MARK: - Binding
    override func bindViewModel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let strongself = self,
                  let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                isLoading ? strongself.spinner.show(in: strongself.view) : strongself.spinner.dismiss()
            }
        }
        viewModel.messages.bind { [weak self] items in
            guard let strongself = self,
                  let items = items else { return }
            strongself.cellDataSources = items
            strongself.reloadTableView()
        }
    }
}

//MARK: - Extension

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.observeTextChange(text: textView.text)
    }
    
    func textViewDidBeginEditing(_ chatView: UITextView) {
        if chatView.textColor == UIColor.lightGray {
            chatView.text = nil
            chatView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ chatView: UITextView) {
        if chatView.text.isEmpty {
            chatView.text = "Placeholder"
            chatView.textColor = UIColor.lightGray
        }
    }
}

