//
//  MediaMessageCell.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 21/12/2022.
//

import UIKit

class MediaMessageCell: UITableViewCell {


    @IBOutlet weak var imageMsg: CacheImageView!
    
    var leadingImage: NSLayoutConstraint!
    var trailingImage: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        
//       Initialization code
        imageMsg.layer.cornerRadius = 12
        setupConstraint()
    }
    
    private func setupConstraint() {
        imageMsg.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [ imageMsg.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
                            imageMsg.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
        ]

        NSLayoutConstraint.activate(constraints)
        leadingImage = imageMsg.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16)
        trailingImage = imageMsg.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        leadingImage.isActive = false
        trailingImage.isActive = true
    }

    func setupUI(isSender: Bool){

        leadingImage.isActive = isSender ? false : true
        trailingImage.isActive = isSender ? true : false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
