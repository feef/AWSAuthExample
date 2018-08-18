//
//  AuthenticationFlowController.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/7/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class AuthenticationFlowController: NSObject {
    private let loginFlowController: LoginFlowController
    private let signUpFlowController: SignUpFlowController
    private let navigationController: UINavigationController
    private let cognitoWrapper: CognitoWrapper
    private lazy var showAlertBlock: (UIAlertController) -> Void = { [weak self] alert in
        self?.navigationController.presentOnTopViewController(alert)
    }
    private lazy var deviceManager = DeviceManager(withShowAlertBlock: self.showAlertBlock)
    private lazy var passwordAuthenticationManager: PasswordAuthenticationManager = {
        let showAuthFlowBlock = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.navigationController.setViewControllers([LandingPageViewController(with: strongSelf)], animated: true)
        }
        return PasswordAuthenticationManager(with: cognitoWrapper, showAuthFlowBlock: showAuthFlowBlock)
    }()
    
    static var shared: AuthenticationFlowController?
    
    // MARK: - Init
    
    @discardableResult static func createShared(with navigationController: UINavigationController, and cognitoWrapper: CognitoWrapper) -> AuthenticationFlowController {
        let shared = AuthenticationFlowController(with: navigationController, and: cognitoWrapper)
        self.shared = shared
        return shared
    }
    
    init(with navigationController: UINavigationController, and cognitoWrapper: CognitoWrapper) {
        self.signUpFlowController = SignUpFlowController(with: cognitoWrapper, navigationController)
        self.loginFlowController = LoginFlowController(with: cognitoWrapper, navigationController)
        self.navigationController = navigationController
        self.cognitoWrapper = cognitoWrapper
        super.init()
        cognitoWrapper.userPool.delegate = self
        refresh()
    }
    
    // MARK: - Token management
    
    func refresh() {        
        cognitoWrapper.userPool.clearAll()
        cognitoWrapper.userPool.currentUser()?.getDetails().continueOnSuccessWith { (task) -> AnyObject? in
            return nil
        }
    }
    
    // MARK: - SignUp
    
    func startSignUpFlow() {
        DispatchQueue.main.async {
            if self.navigationController.viewControllers.count != 1 {
                self.navigationController.popToRootViewController(animated: true)
            }
            self.signUpFlowController.startFlow()
        }
    }
    
    func startLoginFlow() {
        DispatchQueue.main.async {
            if self.navigationController.viewControllers.count != 1 {
                self.navigationController.popToRootViewController(animated: true)
            }
            self.loginFlowController.startFlow()
        }
    }
}

// MARK: - AWSCognitoIdentityInteractiveAuthenticationDelegate

extension AuthenticationFlowController: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        return passwordAuthenticationManager
    }
    
    func startRememberDevice() -> AWSCognitoIdentityRememberDevice {
        return deviceManager
    }
}
