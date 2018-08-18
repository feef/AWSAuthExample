//
//  UIAlertAction.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 6/2/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

extension UIAlertAction {
    static func okayAction(withHandler handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: LocalizedString.okay, style: .default, handler: handler)
    }
}
