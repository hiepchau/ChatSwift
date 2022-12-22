//
//  MessageViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 22/12/2022.
//

import UIKit

class MessageViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var attachBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.separatorStyle = .none
    }


}
