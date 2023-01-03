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

    static var identifier: String {
        get {
            return "ConversationTableViewCell"
        }
    }
    
    static func register() -> UINib {
        UINib(nibName: "ConversationTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var msg: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
         self.selectionStyle = .none
        imgView.dropShadow()
    }
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        /// Configure the view for the selected state
    }

    public func configure(with viewModel: ConversationTableCellViewModel) {
//      userMessageLabel.text = model.latestMessage.text
        usernameLabel.text = viewModel.username
        msg.text = viewModel.msg
        imgView.image = viewModel.imgView
        
        //TODO: Picture profile
//        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
//            switch result {
//            case .success(let url):
//
//                DispatchQueue.main.async {
//                    self?.userImageView.sd_setImage(with: url, completed: nil)
//                }
//
//            case .failure(let error):
//                print("failed to get image url: \(error)")
//            }
//        })
    }

}
