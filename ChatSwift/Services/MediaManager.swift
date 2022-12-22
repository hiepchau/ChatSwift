//
//  MediaManager.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 21/12/2022.
//

import Foundation
import UIKit

final class MediaManager {
    static let shared = MediaManager()
    
}

class CacheImageView: UIImageView
{

    private let imageCache = NSCache<AnyObject, UIImage>()

    func loadImage(fromURL imageURL: URL)
    {
        self.image = UIImage(systemName: "photo")

        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject)
        {
            debugPrint("image loaded from cache for =\(imageURL)")
            self.image = cachedImage
            return
        }

        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: imageURL)
            {
                debugPrint("image downloaded from server...")
                if let image = UIImage(data: imageData)
                {
                    DispatchQueue.main.async {
                        self!.imageCache.setObject(image, forKey: imageURL as AnyObject)
                        self?.image = image.resizeWithScaleAspectFitMode(to: CGFloat(300))
                    }
                }
            }
        }
    }
}
