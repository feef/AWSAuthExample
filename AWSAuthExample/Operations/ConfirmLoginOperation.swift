//
//  ConfirmLoginOperation.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/28/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

class ConfirmLoginOperation: AsynchronousOperation {
    enum Result {
        case success, failure(Error)
    }
    typealias Completion = (Result) -> Void
    
    private let cognitoWrapper: CognitoWrapper
    private let respondToChallengeRequest: AWSCognitoIdentityProviderRespondToAuthChallengeRequest
    let onComplete: Completion
    
    init(_ cognitoWrapper: CognitoWrapper, phoneNumber: String, session: String, loginCode: String, onComplete: @escaping Completion) {
        self.cognitoWrapper = cognitoWrapper
        let respondToChallengeRequest = AWSCognitoIdentityProviderRespondToAuthChallengeRequest()!
        respondToChallengeRequest.challengeName = .customChallenge
        respondToChallengeRequest.clientId = cognitoWrapper.authenticationConstants.clientID
        respondToChallengeRequest.challengeResponses = [
            "USERNAME": phoneNumber,
            "ANSWER": loginCode
        ]
        respondToChallengeRequest.session = session
        self.respondToChallengeRequest = respondToChallengeRequest
        self.onComplete = onComplete
        super.init()
    }
    
    override func start() {
        super.start()
        cognitoWrapper.identityProvider.respond(toAuthChallenge: respondToChallengeRequest) { [weak self] response, error in
            guard let strongSelf = self else {
                return
            }
            defer {
                strongSelf.state = .finished
            }
            
            if let error = error {
                strongSelf.onComplete(.failure(error))
            } else {
                strongSelf.onComplete(.success)
            }
        }
    }
}
