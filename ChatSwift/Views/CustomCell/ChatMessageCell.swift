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
    var leadingBubble: NSLayoutConstraint!
    var trailingBubble: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.cornerRadius = 12
        leadingBubble = bubbleView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16)
        trailingBubble = bubbleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        
        leadingBubble.isActive = false
        trailingBubble.isActive = true
        // Initialization code
    }
    
    func setupUI(isSender: Bool){
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        msglabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [ msglabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 16),
                           msglabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -16),
                           msglabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16),
                           msglabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16),
                            
                            bubbleView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
                            bubbleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10 ),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        leadingBubble.isActive = isSender ? false : true
        trailingBubble.isActive = isSender ? true : false
        

        bubbleView.backgroundColor = isSender ? UIColor(named: "MessageColor") : UIColor(named: "ReceiveMessageColor")

        msglabel.textColor = isSender ? .white : .black
    }
          
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
