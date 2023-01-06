//
//  ChatViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 04/01/2023.
//

import UIKit
import JGProgressHUD

class ChatViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextView: UITextView!
    private let spinner = JGProgressHUD(style: .dark)
    
    //Viewmodel
    var viewModel: ChatViewModel
    var cellDataSources: [ChatTableCellViewModel] = []
    
    //init
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
        inputTextView.delegate = self
        setupTableView()
        bindViewModel()
        configView()
        print("Current chat room ID: \(viewModel.currentConversationID)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputTextView.becomeFirstResponder()
        viewModel.getData()
    }
    
    private func configView() {
        self.title = viewModel.currentConversationName
    }
    
    
    //MARK: - Action sheet
        private func presentInputActionSheet() {
            let actionSheet = UIAlertController(title: "Attach Media",
                                                message: "What would you like to attach?",
                                                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
                self?.presentPhotoInputActionsheet()
            }))
            actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: { [weak self]  _ in
                self?.presentVideoInputActionsheet()
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
            present(actionSheet, animated: true)
        }
    
        private func presentPhotoInputActionsheet() {
            let actionSheet = UIAlertController(title: "Attach Photo",
                                                message: "Where would you like to attach a photo from",
                                                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true
                self?.present(picker, animated: true)
            }))
    
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self?.present(picker, animated: true)
    
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
            present(actionSheet, animated: true)
        }
    
        private func presentVideoInputActionsheet() {
            let actionSheet = UIAlertController(title: "Attach Video",
                                                message: "Where would you like to attach a video from?",
                                                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
    
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.mediaTypes = ["public.movie"]
                picker.videoQuality = .typeMedium
                picker.allowsEditing = true
                self?.present(picker, animated: true)
    
            }))
            actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { [weak self] _ in
    
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                picker.mediaTypes = ["public.movie"]
                picker.videoQuality = .typeMedium
                self?.present(picker, animated: true)
            }))
    
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
            present(actionSheet, animated: true)
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

