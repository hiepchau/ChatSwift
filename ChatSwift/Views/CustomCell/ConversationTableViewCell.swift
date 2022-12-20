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

    static let identifier = "ConversationTableViewCell"
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

        // Configure the view for the selected state
    }

    public func configure(with model: ConversationModel) {
//        userMessageLabel.text = model.latestMessage.text
        usernameLabel.text = model.name
        imgView.image = UIImage(named: "profile")
        
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
