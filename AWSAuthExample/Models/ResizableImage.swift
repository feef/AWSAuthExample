//
//  ResizableImage.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/10/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

enum ResizableImage {
    case blackBorder, greenWhiteBorder, solid
    
    var image: UIImage {
        let image: UIImage
        switch self {
            case .blackBorder:
                image = #imageLiteral(resourceName: "border8Fold")
            case .greenWhiteBorder:
                image = #imageLiteral(resourceName: "greenWhiteBorder")
            case .solid:
                image = #imageLiteral(resourceName: "solidWhite")
        }
        return image.resizableImage(withCapInsets: edgeInsets)
    }
    
    private var edgeInsets: UIEdgeInsets {
        switch self {
            case .blackBorder, .solid, .greenWhiteBorder:
                return UIEdgeInsetsMake(22, 22, 22, 22)
        }
    }
}
