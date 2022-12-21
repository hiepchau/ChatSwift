//
//  TestViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 19/12/2022.
//

import UIKit


enum Kind {
    case text(String)
    case photo(UIImage)
}

struct ChatMessage {
    let isSender: Bool
    let date: Date
    let kind: Kind
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
        ChatMessage(isSender: false, date: Date.dateFromCustomString(customString: "19/10/2022"), kind: .text("Toi la ai")),
        ChatMessage(isSender: true, date: Date.dateFromCustomString(customString: "19/10/2022"), kind: .text("Toi la toi")),
        ChatMessage(isSender: true, date: Date.dateFromCustomString(customString: "19/10/2022"), kind: .text("Em la ai")),
        ChatMessage(isSender: false, date: Date.dateFromCustomString(customString: "18/12/2022"), kind: .text("Em la em")),
        ChatMessage(isSender: true, date: Date.dateFromCustomString(customString: "18/12/2022"), kind: .text("""
            The club isn't the best place to find a lover
            So the bar is where I go
            Me and my friends at the table doing shots
            Drinking fast and then we talk slow
            """)),
        ChatMessage(isSender: false, date: Date.dateFromCustomString(customString: "20/10/2022"), kind: .text("Toi la ai")),
        ChatMessage(isSender: true, date: Date.dateFromCustomString(customString: "20/10/2022"), kind: .text("Toi la toi")),
        ChatMessage(isSender: true, date: Date.dateFromCustomString(customString: "20/10/2022"), kind: .text("Em la ai")),
        ChatMessage(isSender: false, date: Date.dateFromCustomString(customString: "20/12/2022"), kind: .text("Em la em")),
        ChatMessage(isSender: true, date: Date.dateFromCustomString(customString: "21/12/2022"), kind: .text("""
            The club isn't the best place to find a lover
            So the bar is where I go
            Me and my friends at the table doing shots
            Drinking fast and then we talk slow
            """)),
        ChatMessage(isSender: false, date: Date.dateFromCustomString(customString: "21/12/2022"), kind: .photo(UIImage(named: "image-template1")!)),
        ChatMessage(isSender: true, date: Date.dateFromCustomString(customString: "21/12/2022"), kind: .photo(UIImage(named: "image-template2")!)),
        ChatMessage(isSender: true, date: Date.dateFromCustomString(customString: "21/12/2022"), kind: .photo(UIImage(named: "image-template3")!)),
        ChatMessage(isSender: false, date: Date.dateFromCustomString(customString: "21/12/2022"), kind: .photo(UIImage(named: "image-template4")!)),
        ChatMessage(isSender: false, date: Date.dateFromCustomString(customString: "21/12/2022"), kind: .photo(UIImage(named: "image-template5")!)),
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

    func resizeImageWithAspect(image: UIImage,scaledToMaxWidth width:CGFloat,maxHeight height :CGFloat)->UIImage? {
        let oldWidth = image.size.width;
        let oldHeight = image.size.height;
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
        
        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize,false,UIScreen.main.scale);
        
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage
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
        let textCell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! ChatMessageCell
        let imgCell = tableView.dequeueReusableCell(withIdentifier: "imgCell", for: indexPath) as! ImageMessageCell
//        cell.trailingLabel.priority = UILayoutPriority(999)
        let item = msg[indexPath.section][indexPath.row]
        
        switch item.kind {
        case .text(let textMsg):
            textCell.msglabel.text = textMsg
            textCell.setupUI(isSender: item.isSender)
            return textCell
        case .photo(let img):
            let resimg = resizeImageWithAspect(image: img, scaledToMaxWidth: 300, maxHeight: 300)
                imgCell.imageMsg.image = resimg!.resizeWithScaleAspectFitMode(to: CGFloat(2000))
                imgCell.setupUI(isSender: item.isSender)
                return imgCell
        }
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



