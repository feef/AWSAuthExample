//
//  FlowController.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/7/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

typealias CancelHandler = () -> Void

protocol FlowController {
    associatedtype Builder
    typealias StepGenerator = (Builder) -> UIViewController?
    var currentFlowLink: Link<StepGenerator>! { get }
    var navigationController: UINavigationController { get }
    
    init(with cognitoWrapper: CognitoWrapper, _ navigationController: UINavigationController, _ authenticationConstants: AuthenticationConstants)
    func createBuilder() -> Builder
    func setupSteps()
    
    func startFlow()
    func pushNextViewController(with builder: Builder) -> Link<StepGenerator>?
}

extension FlowController {
    func startFlow() {
        setupSteps()
        guard let viewController = currentFlowLink.current(createBuilder()) else {
            navigationController.topViewController!.showDefaultErrorAlert()
            return
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func pushNextViewController(with builder: Builder) -> Link<StepGenerator>? {
        guard
            let nextFlowLink = currentFlowLink.next,
            let viewController = nextFlowLink.current(builder)
        else {
            navigationController.topViewController!.showDefaultErrorAlert()
            return nil
        }
        navigationController.pushViewController(viewController, animated: true)
        return nextFlowLink
    }
}
