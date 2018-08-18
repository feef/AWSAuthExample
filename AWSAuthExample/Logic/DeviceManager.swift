//
//  DeviceManager.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/21/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

class DeviceManager: NSObject {
    let showAlertBlock: (UIAlertController) -> Void
    
    // MARK: - Init
    
    init(withShowAlertBlock showAlertBlock: @escaping (UIAlertController) -> Void) {
        self.showAlertBlock = showAlertBlock
        super.init()
    }
}

// MARK: - AWSCognitoIdentityRememberDevice

extension DeviceManager: AWSCognitoIdentityRememberDevice {
    func getRememberDevice(_ rememberDeviceCompletionSource: AWSTaskCompletionSource<NSNumber>) {
        let alertController = UIAlertController(title: LocalizedString.rememberDeviceTitle,
                                                message: LocalizedString.rememberDeviceMessage,
                                                preferredStyle: .actionSheet)
        
        let yesAction = UIAlertAction(title: LocalizedString.yes, style: .default, handler: { (action) in
            rememberDeviceCompletionSource.set(result: true)
        })
        let noAction = UIAlertAction(title: LocalizedString.no, style: .default, handler: { (action) in
            rememberDeviceCompletionSource.set(result: false)
        })
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        DispatchQueue.main.async {
            self.showAlertBlock(alertController)
        }
    }
    
    func didCompleteStepWithError(_ error: Error?) {
        if let error = error as NSError? {
            let alertController = UIAlertController(title: error.awsErrorTitle,
                                                    message: error.awsErrorMessage,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction.okayAction())
            DispatchQueue.main.async {
                self.showAlertBlock(alertController)
            }
        }
    }
}
