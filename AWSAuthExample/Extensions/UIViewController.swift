//
//  UIViewController.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 5/21/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

extension UIViewController {
    func showDefaultErrorAlert() {
        present(UIAlertController.defaultErrorController, animated: true, completion: nil)
    }
}
