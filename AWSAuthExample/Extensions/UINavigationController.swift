//
//  UINavigationController.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/21/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

extension UINavigationController {
    func presentOnTopViewController(_ viewControllerToPresent: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        
        let viewControllerIsPresented = self.presentedViewController != nil
        let presentingViewController: UIViewController
        if let currentPresentingViewController = self.presentingViewController {
            presentingViewController = currentPresentingViewController
        } else if let topViewController = self.topViewController {
            presentingViewController = topViewController
        } else {
            // TODO: Log error, should never make it here
            return
        }
        let showViewController = {
            presentingViewController.present(viewControllerToPresent, animated: animated, completion: completion)
        }
        
        if viewControllerIsPresented {
            self.dismiss(animated: true, completion: showViewController)
        } else {
            showViewController()
        }
    }
}
