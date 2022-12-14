//
//  PhotoViewController.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 14/12/2022.
//

import Foundation
import UIKit
import SDWebImage

final class PhotoViewerViewController: UIViewController {

    private let url: URL

    init(with url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let imageView: CacheImageView = {
        let imageView = CacheImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .black
        view.addSubview(imageView)
        imageView.loadImage(fromURL: url)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }
}
