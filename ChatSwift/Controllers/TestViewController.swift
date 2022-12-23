////
////  TestViewController.swift
////  ChatSwift
////
////  Created by Châu Hiệp on 19/12/2022.
////
//
//import UIKit
//
//
//
//
//extension Date {
//    static func dateFromCustomString(customString: String) -> Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        return dateFormatter.date(from: customString) ?? Date()
//    }
//}
//
//class TestViewController: UIViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var chatView: UITextView!
//    @IBOutlet weak var AttachBtn: UIButton!
//    @IBOutlet weak var SendBtn: UIButton!
//
//    var msg = [[Message]]()
//
//    var messagesFromServer = [
//        Message(isSender: false, date: Date.dateFromCustomString(customString: "19/10/2022"), kind: .text("Toi la ai")),
//        Message(isSender: true, date: Date.dateFromCustomString(customString: "21/12/2022"), kind: .text("""
//            The club isn't the best place to find a lover
//            So the bar is where I go
//            Me and my friends at the table doing shots
//            Drinking fast and then we talk slow
//            """)),
//        Message(isSender: false, date: Date.dateFromCustomString(customString: "21/12/2022"), kind: .photo(UIImage(named: "image-template1")!)),
//    ]
//
//    fileprivate func attemptToAssembleGroupedMessages(){
//
//        let groupedMessages = Dictionary(grouping: messagesFromServer) { (element) -> Date in
//            return element.date
//        }
//
//        let sortedKeys = groupedMessages.keys.sorted()
//        sortedKeys.forEach { (key) in
//            let values = groupedMessages[key]
//            msg.append(values ?? [])
//        }
//
////        groupedMessages.keys.forEach { (key) in
////            let values = groupedMessages[key]
////            msg.append(values ?? [])
////        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//        setupChatView()
//        chatView.delegate = self
//
//    }
//
//    private func setupChatView() {
//        chatView.text = "Aa"
//        chatView.textColor = UIColor.lightGray
//    }
//
//    private func setupTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        attemptToAssembleGroupedMessages()
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.separatorStyle = .none
//    }
//
//    @IBAction func didTapSendButton(_ sender: Any) {
//        if !chatView.text.replacingOccurrences(of: " ", with: "").isEmpty{
//            print(chatView.text!)
//            chatView.text = nil
//            messagesFromServer.append(Message(isSender: true, date: Date(), kind: .text(chatView.text)))
//        } else{
//            return
//        }
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
//
//}
//extension TestViewController: UITextViewDelegate {
//    func textViewDidBeginEditing(_ chatView: UITextView) {
//        if chatView.textColor == UIColor.lightGray {
//            chatView.text = nil
//            chatView.textColor = UIColor.black
//        }
//    }
//
//    func textViewDidEndEditing(_ chatView: UITextView) {
//        if chatView.text.isEmpty {
//            chatView.text = "Placeholder"
//            chatView.textColor = UIColor.lightGray
//        }
//    }
//}
//
//extension TestViewController: UITableViewDelegate, UITableViewDataSource{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return msg[section].count
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return msg.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let textCell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! ChatMessageCell
//        let imgCell = tableView.dequeueReusableCell(withIdentifier: "imgCell", for: indexPath) as! MediaMessageCell
//
//        let item = msg[indexPath.section][indexPath.row]
//
//        switch item.kind {
//        case .text(let textMsg):
//            textCell.msglabel.text = textMsg
//            textCell.setupUI(isSender: item.isSender)
//            return textCell
//        case .photo(let img):
//            imgCell.imageMsg.image = img.resizeWithScaleAspectFitMode(to: CGFloat(300))
//            imgCell.setupUI(isSender: item.isSender)
//            return imgCell
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        if let firstMessageInsection = msg[section].first {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd/MM/yyyy"
//            let dateString = dateFormatter.string(from: firstMessageInsection.date)
//
//            let label = DateHeaderLabel()
//            label.backgroundColor = .clear
//            label.text = "DATE STRING"
//            label.textColor = UIColor(named: "HeaderColor")
//            label.textAlignment = .center
//            label.translatesAutoresizingMaskIntoConstraints = false
//            label.font = UIFont.boldSystemFont(ofSize: 14)
//            label.text = dateString
//
//            let containerView = UIView()
//
//            containerView.addSubview(label)
//            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
//            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//
//            return containerView
//
//        }
//        return nil
//    }
//
//}
//
//
//
