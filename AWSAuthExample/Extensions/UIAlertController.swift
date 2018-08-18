//
//  UIAlertController.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 5/21/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

extension UIAlertController {    
    static let defaultErrorController: UIAlertController = {
        let alertController = UIAlertController(title: LocalizedString.error, message: LocalizedString.errorAlertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.okayAction())
        return alertController
    }()
}
