//
//  PasswordAuthenticationManager.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/21/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

class PasswordAuthenticationManager: NSObject {
    let cognitoWrapper: CognitoWrapper
    let showAuthFlowBlock: () -> Void
    
    private var stepError: Error?
    
    // MARK: - Init
    
    init(with cognitoWrapper: CognitoWrapper, showAuthFlowBlock: @escaping () -> Void) {
        self.cognitoWrapper = cognitoWrapper
        self.showAuthFlowBlock = showAuthFlowBlock
        super.init()
    }
}

// MARK: - AWSCognitoIdentityPasswordAuthentication

extension PasswordAuthenticationManager: AWSCognitoIdentityPasswordAuthentication {
    public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        if let stepError = stepError {
            passwordAuthenticationCompletionSource.set(error: stepError)
            self.stepError = nil
            return
        }
        guard let authDetails = cognitoWrapper.authenticationDetails else {
            DispatchQueue.main.async {
                self.showAuthFlowBlock()
            }
            return
        }
        passwordAuthenticationCompletionSource.set(result: authDetails)
    }
    
    public func didCompleteStepWithError(_ error: Error?) {
        if let error = error as NSError? {
            stepError = error
        }
    }
}
