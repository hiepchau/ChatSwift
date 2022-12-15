//
//  Extensions.swift
//  ChatSwift
//
//  Created by Châu Hiệp on 15/12/2022.
//

import Foundation
import UIKit

extension UIView {

    public var width: CGFloat {
        return frame.size.width
    }

    public var height: CGFloat {
        return frame.size.height
    }

    public var top: CGFloat {
        return frame.origin.y
    }

    public var bottom: CGFloat {
        return frame.size.height + frame.origin.y
    }

    public var left: CGFloat {
        return frame.origin.x
    }

    public var right: CGFloat {
        return frame.size.width + frame.origin.x
    }
    
    func dropShadow() {
        DispatchQueue.main.async {  [weak self] in
               guard let this = self else { return }
              this.layer.masksToBounds = false
                  this.layer.shadowColor = UIColor.gray.cgColor
                  this.layer.shadowOpacity = 0.3
                  this.layer.shadowOffset = CGSize.zero
                  this.layer.shadowRadius = 5
                  this.layer.shouldRasterize = true
                  this.layer.rasterizationScale = UIScreen.main.scale
        }
    }

}
