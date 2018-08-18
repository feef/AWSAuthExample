//
//  UserLoginOperation.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/25/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

class UserLoginOperation: AsynchronousOperation, ResultGeneratingOperation {
    enum OperationError: Error {
        case unknown
    }
    
    typealias Completion = (Result<String>) -> Void
    
    private let phoneNumber: String
    private let cognitoWrapper: CognitoWrapper
    private let authenticationRequest: AWSCognitoIdentityProviderInitiateAuthRequest
    let onComplete: Completion
    
    init(_ cognitoWrapper: CognitoWrapper, password: String, phoneNumber: String, _ locale: UserLocale, onComplete: @escaping Completion) {
        self.phoneNumber = locale.phoneNumberCode + phoneNumber
        self.cognitoWrapper = cognitoWrapper
        let authenticationRequest = AWSCognitoIdentityProviderInitiateAuthRequest()!
        authenticationRequest.clientId = cognitoWrapper.authenticationConstants.clientID
        authenticationRequest.authFlow = .customAuth
        authenticationRequest.authParameters = [
            "USERNAME": self.phoneNumber,
            "PASSWORD": password
        ]
        self.authenticationRequest = authenticationRequest
        self.onComplete = onComplete
        super.init()
    }
    
    override func start() {
        super.start()
        cognitoWrapper.authenticationDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: phoneNumber)
        let identityProvider = cognitoWrapper.identityProvider
        identityProvider.initiateAuth(authenticationRequest) { [weak self] response, error in
            guard let strongSelf = self else {
                return
            }
            defer {
                strongSelf.state = .finished
            }
            
            if let error = error {
                strongSelf.onComplete(.failure(error))
            } else if let session = response?.session {
                strongSelf.onComplete(.success(session))
            } else {
                strongSelf.onComplete(.failure(OperationError.unknown))
            }
        }
    }
}
