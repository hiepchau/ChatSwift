//
//  ChatMessageCell.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 19/12/2022.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    @IBOutlet weak var msglabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    
//    @IBOutlet weak var leadingBubble: NSLayoutConstraint!
//    @IBOutlet weak var leadingBubbleTemp: NSLayoutConstraint!
//    @IBOutlet weak var trailingBubble: NSLayoutConstraint!
//    @IBOutlet weak var trailingBubbleTemp: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.cornerRadius = 12
        // Initialization code
    }
    
    func setupUI(isSender: Bool){
        bubbleView.backgroundColor = isSender ? UIColor(named: "MessageColor") : UIColor(named: "ReceiveMessageColor")
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        msglabel.translatesAutoresizingMaskIntoConstraints = false
        msglabel.textColor = isSender ? .white : .black

        let constraints = [ msglabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 16),
                           msglabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -16),
                           msglabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16),
                           msglabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16),
                            
                            bubbleView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
                            bubbleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10 ),
                            bubbleView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
                            bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -16),
        
        ]
        
        NSLayoutConstraint.activate(constraints)
//        leadingBubble.constant = isSender ? 100 : 16
//        leadingBubbleTemp.constant = isSender ? 100 : 16
    
//        trailingBubble.constant = isSender ? 16 : 100
//        trailingBubbleTemp.constant = isSender ? 16 : 100
//        leadingBubble.priority = isSender ? UILayoutPriority(500) : UILayoutPriority(1000)
//        leadingBubbleTemp.priority = isSender ? UILayoutPriority(1000) : UILayoutPriority(500)
//        trailingBubble.priority = isSender ? UILayoutPriority(500) : UILayoutPriority(1000)
//        trailingBubbleTemp.priority = isSender ? UILayoutPriority(1000) : UILayoutPriority(500)
    }
          
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
