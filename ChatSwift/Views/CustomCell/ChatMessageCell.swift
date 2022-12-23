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
    
    var leadingBubble: NSLayoutConstraint!
    var trailingBubble: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.cornerRadius = 12

        // Initialization code
        setupConstraint()
    }
    
    func setupConstraint() {
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        msglabel.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [ msglabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
                            msglabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8),
                            msglabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16),
                            msglabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16),
                
                            bubbleView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
                            bubbleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5 ),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        leadingBubble = bubbleView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16)
        trailingBubble = bubbleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        
        leadingBubble.isActive = false
        trailingBubble.isActive = true
    }
    
    func setupUI(isSender: Bool){
        
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
