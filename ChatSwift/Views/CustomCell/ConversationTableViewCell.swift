//
//  ConversationTableViewCell.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 13/12/2022.
//
import Foundation

import UIKit
import SDWebImage

class ConversationTableViewCell: UITableViewCell {
    
    //MARK: - Identifier
    static var identifier: String {
        get {
            return "ConversationTableViewCell"
        }
    }
    
    static func register() -> UINib {
        UINib(nibName: "ConversationTableViewCell", bundle: nil)
    }
    //MARK: - IBOulets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var msg: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var stateView: UIImageView!
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        imgView.dropShadow()
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    public func setupUI(with viewModel: ConversationTableCellViewModel)  {
//      userMessageLabel.text = model.latestMessage.text
        usernameLabel.text = viewModel.username
        msg.text = viewModel.msg
        imgView.image = viewModel.imgView
        viewModel.isOnline { res in
            self.stateView.isHidden = !res
        }
    }

}
