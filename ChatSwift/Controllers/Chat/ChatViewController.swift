//
//  ChatViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 04/01/2023.
//

import UIKit

class ChatViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextView: UITextView!
    
    var viewModel: ChatViewModel
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputTextView.becomeFirstResponder()
        viewModel.getData()
    }
    
    //MARK: - IBActions
    
    @IBAction func sendButtonDidTouch(_ sender: UIButton) {
        viewModel.sendMesage()
        inputTextView.text = nil
    }
    
    
    //MARK: - Binding


}

//MARK: - Extension

extension ChatViewController: UITextViewDelegate {

    private func textFieldDidChange(_ textField: UITextField) {
        viewModel.observeTextChange(text: textField.text)
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
