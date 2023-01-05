//
//  MediaMessageCell.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 21/12/2022.
//

import UIKit

class MediaMessageCell: UITableViewCell {

    //MARK: - Identifier
    
    static var identifier: String {
        get {
            return "MediaMessageCell"
        }
    }
    
    static func register() -> UINib {
        UINib(nibName: "MediaMessageCell", bundle: nil)
    }
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var imageMsg: CacheImageView!
    
    private var leadingImage: NSLayoutConstraint!
    private var trailingImage: NSLayoutConstraint!
    
    //MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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

    func setupUI(with viewModel: ChatTableCellViewModel){
        
        ///Setup UI
        leadingImage.isActive = viewModel.isSender ? false : true
        trailingImage.isActive = viewModel.isSender ? true : false
    
        ///Setup viewmodel
        guard let url = viewModel.msg as? URL else {return}
        self.imageMsg.loadImage(fromURL: url)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
