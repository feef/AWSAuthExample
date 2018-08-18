//
//  ConfirmSignUpOperation.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/28/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

class ConfirmSignUpOperation: AsynchronousOperation {
    enum Result {
        case success, failure(Error)
    }
    typealias Completion = (Result) -> Void
    
    private let cognitoWrapper: CognitoWrapper
    private let user: AWSCognitoIdentityUser
    private let signUpCode: String
    let onComplete: Completion
    
    init(_ cognitoWrapper: CognitoWrapper, _ user: AWSCognitoIdentityUser, signUpCode: String, onComplete: @escaping Completion) {
        self.cognitoWrapper = cognitoWrapper
        self.user = user
        self.signUpCode = signUpCode
        self.onComplete = onComplete
        super.init()
    }
    
    override func start() {
        super.start()
        
        user.confirmSignUp(signUpCode, forceAliasCreation: true).continueWith { [weak self] (task: AWSTask) -> AnyObject? in
            guard let strongSelf = self else {
                return nil
            }
            defer {
                strongSelf.state = .finished
            }
            if let error = task.error {
                strongSelf.onComplete(.failure(error))
            } else {
                strongSelf.onComplete(.success)
            }
            return nil
        }
    }
}
