//
//  AccessoryFriendlyTextField.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 5/1/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

class AccessoryFriendlyTextField: UITextField {
    enum ViewSide {
        case left, right
    }
    
    var viewRectCaluclationBlock: ((AccessoryFriendlyTextField, ViewSide, CGRect) -> CGRect)?
        
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return viewRectCaluclationBlock?(self, .left, bounds) ?? .zero
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return viewRectCaluclationBlock?(self, .right, bounds) ?? .zero
    }
}


