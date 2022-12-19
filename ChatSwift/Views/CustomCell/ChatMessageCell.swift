//
//  ChatMessageCell.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 19/12/2022.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    @IBOutlet weak var msglabel: UILabel!
    @IBOutlet weak var trailingLabel: NSLayoutConstraint!
    @IBOutlet weak var leadingLabel: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

  
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
