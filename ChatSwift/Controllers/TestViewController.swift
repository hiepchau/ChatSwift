//
//  TestViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 19/12/2022.
//

import UIKit


struct ChatMessage {
    let text:String
    let isSender: Bool
    let date: Date
}

extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
}

class TestViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var msg = [[ChatMessage]]()
    
    let messagesFromServer = [
        ChatMessage(text: "Toi la ai", isSender: false, date: Date.dateFromCustomString(customString: "19/10/2022")),
        ChatMessage(text: "Toi la toi", isSender: true, date: Date.dateFromCustomString(customString: "19/10/2022")),
        ChatMessage(text: "Em la ai", isSender: true, date: Date.dateFromCustomString(customString: "19/10/2022")),
        ChatMessage(text: "Em la em", isSender: false, date: Date.dateFromCustomString(customString: "20/12/2022")),
        ChatMessage(text: """
            The club isn't the best place to find a lover
            So the bar is where I go
            Me and my friends at the table doing shots
            Drinking fast and then we talk slow
            """, isSender: true, date: Date.dateFromCustomString(customString: "20/12/2022")),
        ChatMessage(text: """
            The club isn't the best place to find a lover
            So the bar is where I go
            Me and my friends at the table doing shots
            Drinking fast and then we talk slow
            """, isSender: false, date: Date.dateFromCustomString(customString: "20/12/2022")),
        ChatMessage(text: "Toi la ai", isSender: false, date: Date.dateFromCustomString(customString: "19/10/2022")),
        ChatMessage(text: "Toi la toi", isSender: true, date: Date.dateFromCustomString(customString: "19/10/2022")),
        ChatMessage(text: "Em la ai", isSender: true, date: Date.dateFromCustomString(customString: "19/10/2022")),
        ChatMessage(text: "Em la em", isSender: false, date: Date.dateFromCustomString(customString: "20/12/2022")),
        ChatMessage(text: """
            The club isn't the best place to find a lover
            So the bar is where I go
            Me and my friends at the table doing shots
            Drinking fast and then we talk slow
            """, isSender: true, date: Date.dateFromCustomString(customString: "20/12/2022")),
        ChatMessage(text: """
            The club isn't the best place to find a lover
            So the bar is where I go
            Me and my friends at the table doing shots
            Drinking fast and then we talk slow
            """, isSender: false, date: Date.dateFromCustomString(customString: "20/12/2022")),
        ChatMessage(text: "Toi la ai", isSender: false, date: Date.dateFromCustomString(customString: "19/10/2022")),
        ChatMessage(text: "Toi la toi", isSender: true, date: Date.dateFromCustomString(customString: "19/10/2022")),
        ChatMessage(text: "Em la ai", isSender: true, date: Date.dateFromCustomString(customString: "19/10/2022")),
        ChatMessage(text: "Em la em", isSender: false, date: Date.dateFromCustomString(customString: "20/12/2022")),
        ChatMessage(text: """
            The club isn't the best place to find a lover
            So the bar is where I go
            Me and my friends at the table doing shots
            Drinking fast and then we talk slow
            """, isSender: true, date: Date.dateFromCustomString(customString: "20/12/2022")),
        ChatMessage(text: """
            The club isn't the best place to find a lover
            So the bar is where I go
            Me and my friends at the table doing shots
            Drinking fast and then we talk slow
            """, isSender: false, date: Date.dateFromCustomString(customString: "20/12/2022"))
    ]
    
    fileprivate func attemptToAssembleGroupedMessages(){
    
        
        let groupedMessages = Dictionary(grouping: messagesFromServer) { (element) -> Date in
            return element.date
        }
        
        let sortedKeys = groupedMessages.keys.sorted()
        sortedKeys.forEach { (key) in
            let values = groupedMessages[key]
            msg.append(values ?? [])
        }
        
//        groupedMessages.keys.forEach { (key) in
//            let values = groupedMessages[key]
//            msg.append(values ?? [])
//        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
     
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        attemptToAssembleGroupedMessages()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
}

extension TestViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msg[section].count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return msg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as! ChatMessageCell
    
//        cell.trailingLabel.priority = UILayoutPriority(999)
        cell.msglabel.text = msg[indexPath.section][indexPath.row].text
        cell.setupUI(isSender: msg[indexPath.section][indexPath.row].isSender)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let firstMessageInsection = msg[section].first {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: firstMessageInsection.date)
            
            let label = DateHeaderLabel()
            label.backgroundColor = .clear
            label.text = "DATE STRING"
            label.textColor = UIColor(named: "HeaderColor")
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.text = dateString
            
            let containerView = UIView()
            
            containerView.addSubview(label)
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            
            return containerView
            
        }
        return nil
    }

}

class DateHeaderLabel: UILabel {
    
    override var intrinsicContentSize: CGSize{
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + 12
        layer.cornerRadius = height / 2
        layer.masksToBounds = true
        return CGSize(width: originalContentSize.width + 16, height: height)
    }
}
