//
//  SignUpFlowController.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/7/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

final class SignUpFlowController: FlowController {
    struct SignUpBuilder {
        var userSignUpOperationBuilder = UserSignUpOperation.Builder()
        var user: AWSCognitoIdentityUser?
    }
    
    typealias Builder = SignUpBuilder
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
        var builder = Builder()
        builder.userSignUpOperationBuilder.cognitoWrapper = cognitoWrapper
        builder.userSignUpOperationBuilder.password = authenticationConstants.password
        return builder
    }
    
    func setupSteps() {
        let preSignUpViewController = navigationController.topViewController!
        let cancelHandler: () -> Void = { [navigationController] in
            navigationController.popToViewController(preSignUpViewController, animated: true)
        }
        let showAlert: (Error?) -> Void = { [navigationController] error in
            let alertController: UIAlertController
            defer {
                alertController.addAction(UIAlertAction.okayAction())
                navigationController.topViewController!.present(alertController, animated: true, completion: nil)
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
                var updatedBuilder = builder
                let completion = { [weak self] (firstName: String, lastName: String) in
                    guard let strongSelf = self else {
                        return
                    }
                    updatedBuilder.userSignUpOperationBuilder.firstName = firstName
                    updatedBuilder.userSignUpOperationBuilder.lastName = lastName
                    strongSelf.currentFlowLink = strongSelf.pushNextViewController(with: updatedBuilder)
                }
                let nameEntryViewController = NameEntryViewController(completion: completion, andCancelHandler: cancelHandler)
                nameEntryViewController.title = LocalizedString.signUp
                return nameEntryViewController
            },
            { builder in
                let completion = { [weak self] (locale: UserLocale, phoneNumber: String, phoneNumberEntryViewController: PhoneNumberEntryViewController) in
                    guard let strongSelf = self else {
                        return
                    }
                    DispatchQueue.main.async {
                        phoneNumberEntryViewController.showLoadingUI(true)
                    }
                    var updatedBuilder = builder
                    updatedBuilder.userSignUpOperationBuilder.locale = locale
                    updatedBuilder.userSignUpOperationBuilder.phoneNumber = phoneNumber
                    let signUpOperation = try? updatedBuilder.userSignUpOperationBuilder.build { result in
                        switch result {
                            case .success(let user):
                                updatedBuilder.user = user
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
                    guard let operation = signUpOperation else {
                        strongSelf.navigationController.topViewController!.showDefaultErrorAlert()
                        return
                    }
                    OperationQueue.main.addOperation(operation)
                }
                let phoneNumberEntryViewController = PhoneNumberEntryViewController(completion: completion, andCancelHandler: cancelHandler)
                phoneNumberEntryViewController.title = LocalizedString.signUp
                return phoneNumberEntryViewController
            },
            { [cognitoWrapper] builder in
                guard let user = builder.user else {
                    return nil
                }
                let completion = { [weak self] (signUpCode: String, deviceConfirmationViewController: DeviceConfirmationViewController) in
                    guard let strongSelf = self else {
                        return
                    }
                    DispatchQueue.main.async {
                        deviceConfirmationViewController.showLoadingUI(true)
                    }
                    let confirmSignUpOperation = ConfirmSignUpOperation(strongSelf.cognitoWrapper, user, signUpCode: signUpCode) { result in
                        switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    // TODO: Push to authenticated, inside-app view controller
                                    let alert = UIAlertController(title: "Sign up succeeded!", message: "Woo!!", preferredStyle: .alert)
                                    strongSelf.navigationController.presentOnTopViewController(alert)
                                }
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    deviceConfirmationViewController.showLoadingUI(false)
                                }
                                showAlert(error)
                        }
                    }
                    OperationQueue.main.addOperation(confirmSignUpOperation)
                }
                return DeviceConfirmationViewController(cognitoWrapper, completion: completion, andCancelHandler: cancelHandler)
            }
        ]
        currentFlowLink = stepGenerators.linkedList()
    }
}
