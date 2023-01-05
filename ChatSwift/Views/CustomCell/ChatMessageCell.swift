//
//  ChatMessageCell.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 19/12/2022.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    
    //MARK: - Identifier
    
    static var identifier: String {
        get {
            return "ChatMessageCell"
        }
    }
    
    static func register() -> UINib {
        UINib(nibName: "ChatMessageCell", bundle: nil)
    }
    
    //MARK: - IBOulets
    
    @IBOutlet weak var msglabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    
    private var leadingBubble: NSLayoutConstraint!
    private var trailingBubble: NSLayoutConstraint!
    
    //MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        bubbleView.layer.cornerRadius = 12
        setupConstraint()
    }
    
    private func setupConstraint() {
   
        
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
    
    func setupUI(with viewModel: ChatTableCellViewModel){
        
        ///SetupUI
        leadingBubble.isActive = viewModel.isSender ? false : true
        trailingBubble.isActive = viewModel.isSender ? true : false
        
        bubbleView.backgroundColor = viewModel.isSender ? UIColor(named: "MessageColor") : UIColor(named: "ReceiveMessageColor")

        msglabel.textColor = viewModel.isSender ? .white : .black
        
        ///Setup viewmodel
        if let text = viewModel.msg as? String, !text.isEmpty {
            msglabel.text = text
        }
    }
          
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
