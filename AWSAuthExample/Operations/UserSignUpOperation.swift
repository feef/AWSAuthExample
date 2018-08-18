//
//  UserSignUpOperation.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/8/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

class UserSignUpOperation: AsynchronousOperation, ResultGeneratingOperation {
    enum OperationError: Error {
        case missingProperties, unknown
    }
    
    typealias Completion = (Result<AWSCognitoIdentityUser>) -> Void
    
    struct Builder {
        var cognitoWrapper: CognitoWrapper?
        var password: String?
        var firstName: String?
        var lastName: String?
        var phoneNumber: String?
        var locale: UserLocale?
        
        func build(onComplete: @escaping Completion) throws -> UserSignUpOperation {
            guard
                let cognitoWrapper = cognitoWrapper,
                let password = password,
                let firstName = firstName,
                let lastName = lastName,
                let phoneNumber = phoneNumber,
                let locale = locale
            else {
                throw OperationError.missingProperties
            }
            
            return UserSignUpOperation(cognitoWrapper, password: password, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, locale, onComplete: onComplete)
        }
    }
    
    private let cognitoWrapper: CognitoWrapper
    private let password: String
    private let attributes: [AWSCognitoIdentityUserAttributeType]
    let onComplete: Completion
    
    init(_ cognitoWrapper: CognitoWrapper, password: String, firstName: String, lastName: String, phoneNumber: String, _ locale: UserLocale, onComplete: @escaping Completion) {
        self.cognitoWrapper = cognitoWrapper
        self.password = password
        attributes = [
            AWSCognitoIdentityUserAttributeType(key: .phone, value: locale.phoneNumberCode + phoneNumber),
            AWSCognitoIdentityUserAttributeType(key: .firstName, value: firstName),
            AWSCognitoIdentityUserAttributeType(key: .lastName, value: lastName),
            AWSCognitoIdentityUserAttributeType(key: .locale, value: locale.abbreviation)
        ]
        self.onComplete = onComplete
        super.init()
    }
    
    override func start() {
        super.start()
        let username = "user_id-" + NSUUID().uuidString
        cognitoWrapper.userPool.signUp(username, password: password, userAttributes: attributes, validationData: nil).continueWith {[weak self] (task) -> Any? in
            guard let strongSelf = self else {
                return nil
            }
            defer {
                strongSelf.state = .finished
            }
            if let error = task.error {
                strongSelf.onComplete(.failure(error))
            } else if let user = task.result?.user {
                strongSelf.onComplete(.success(user))
            } else {
                strongSelf.onComplete(.failure(OperationError.unknown))
            }
            return nil
        }
    }
}
