//
//  LoginFlowController.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/7/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

final class LoginFlowController: NSObject, FlowController {
    struct LoginBuilder {
        var phoneNumber: String?
        var locale: UserLocale?
        var session: String?
    }
    
    typealias Builder = LoginBuilder
    typealias StepGenerator = ((Builder) -> UIViewController?)
    
    private(set) var currentFlowLink: Link<StepGenerator>!
    private let authenticationConstants: AuthenticationConstants
    
    let navigationController: UINavigationController
    let cognitoWrapper: CognitoWrapper
    
    // MARK: - FlowController
    
    init(with cognitoWrapper: CognitoWrapper, _ navigationController: UINavigationController, _ authenticationConstants: AuthenticationConstants = .defaultConstants) {
        self.navigationController = navigationController
        self.cognitoWrapper = cognitoWrapper
        self.authenticationConstants = authenticationConstants
    }
    
    func createBuilder() -> Builder {
        return Builder()
    }
    
    func setupSteps() {
        let preLoginViewController = navigationController.topViewController!
        let cancelHandler: () -> Void = { [navigationController] in
            navigationController.popToViewController(preLoginViewController, animated: true)
        }
        let showAlert: (Error?) -> Void = { [navigationController] error in
            let alertController: UIAlertController
            defer {
                alertController.addAction(UIAlertAction.okayAction())
                DispatchQueue.main.async {
                    navigationController.topViewController!.present(alertController, animated: true, completion: nil)
                }
            }
            guard let error = error as NSError? else {
                alertController = UIAlertController.defaultErrorController
                return
            }
            alertController = UIAlertController(title: error.awsErrorTitle,
                                                message: error.awsErrorMessage,
                                                preferredStyle: .alert)
        }
        
        let stepGenerators: [StepGenerator] = [
            { builder in
                let completion = { [weak self] (locale: UserLocale, phoneNumber: String, phoneNumberEntryViewController: PhoneNumberEntryViewController) in
                    guard let strongSelf = self else {
                        return
                    }
                    DispatchQueue.main.async {
                        phoneNumberEntryViewController.showLoadingUI(true)
                    }
                    let operation = UserLoginOperation(strongSelf.cognitoWrapper, password: strongSelf.cognitoWrapper.authenticationConstants.password, phoneNumber: phoneNumber, locale) { result in
                        switch result {
                            case .success(let session):
                                var updatedBuilder = builder
                                updatedBuilder.phoneNumber = phoneNumber
                                updatedBuilder.locale = locale
                                updatedBuilder.session = session
                                DispatchQueue.main.async {
                                    strongSelf.currentFlowLink = strongSelf.pushNextViewController(with: updatedBuilder)
                                }
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    phoneNumberEntryViewController.showLoadingUI(false)
                                }
                                showAlert(error)
                        }
                    }
                    OperationQueue.main.addOperation(operation)
                }
                let phoneNumberEntryViewController = PhoneNumberEntryViewController(completion: completion, andCancelHandler: cancelHandler)
                phoneNumberEntryViewController.title = "Log In"
                return phoneNumberEntryViewController
            },
            { [cognitoWrapper] builder in
                guard
                    let session = builder.session,
                    let phoneNumber = builder.phoneNumber,
                    let locale = builder.locale
                else {
                    showAlert(nil)
                    return nil
                }
                let completion = { [weak self] (loginCode: String, deviceConfirmationViewController: DeviceConfirmationViewController) in
                    guard let strongSelf = self else {
                        return
                    }
                    DispatchQueue.main.async {
                        deviceConfirmationViewController.showLoadingUI(true)
                    }
                    let confirmLoginOperation = ConfirmLoginOperation(strongSelf.cognitoWrapper, phoneNumber: locale.phoneNumberCode + phoneNumber, session: session, loginCode: loginCode) { result in
                        switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    // TODO: Push to authenticated, inside-app view controller
                                    let alert = UIAlertController(title: "Login succeeded!", message: "Woo!!", preferredStyle: .alert)
                                    strongSelf.navigationController.presentOnTopViewController(alert)
                                }
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    deviceConfirmationViewController.showLoadingUI(false)
                                }
                                showAlert(error)
                        }
                    }
                    OperationQueue.main.addOperation(confirmLoginOperation)
                }
                let deviceConfirmationViewController = DeviceConfirmationViewController(cognitoWrapper, completion: completion, andCancelHandler: cancelHandler)
                deviceConfirmationViewController.title = "Log In"
                return deviceConfirmationViewController
            }
        ]
        currentFlowLink = stepGenerators.linkedList()
    }
}
