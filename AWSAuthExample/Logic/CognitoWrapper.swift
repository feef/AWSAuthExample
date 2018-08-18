//
//  CognitoWrapper.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/7/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider
import AWSLambda

class CognitoWrapper {
    static private(set) var shared: CognitoWrapper?
    
    let authenticationConstants: AuthenticationConstants
    let userPool: AWSCognitoIdentityUserPool
    let credentialsProvider: AWSCognitoCredentialsProvider
    let identityProvider: AWSCognitoIdentityProvider
    var authenticationDetails: AWSCognitoIdentityPasswordAuthenticationDetails?
    
    // MARK: - Init
    
    static func setupShared(with constants: AuthenticationConstants) -> CognitoWrapper {
        let shared = CognitoWrapper(with: constants)
        self.shared = shared
        return shared
    }
    
    init(with constants: AuthenticationConstants) {
        let identityServiceConfiguration = AWSServiceConfiguration(region: constants.region, credentialsProvider: nil)!
        
        // create pool configuration
        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: constants.clientID,
                                                                        clientSecret: nil,
                                                                        poolId: constants.userPoolID)
        
        // initialize user pool client
        AWSCognitoIdentityUserPool.register(with: identityServiceConfiguration, userPoolConfiguration: poolConfiguration, forKey: constants.registrationKey)
        
        let userPool = AWSCognitoIdentityUserPool(forKey: constants.registrationKey)
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: constants.region, identityPoolId: constants.identityPoolID, identityProviderManager: userPool)
        
        // setup service configuration
        let serviceConfiguration = AWSServiceConfiguration(region: constants.region, credentialsProvider: credentialsProvider)!
        
        // initialize lambda invoker
        AWSLambdaInvoker.register(with: serviceConfiguration, forKey: constants.registrationKey)
        
        AWSCognitoIdentityProvider.register(with: serviceConfiguration, forKey: constants.registrationKey)
        
        self.identityProvider = AWSCognitoIdentityProvider(forKey: constants.registrationKey)
        self.userPool = userPool
        self.credentialsProvider = credentialsProvider
        self.authenticationConstants = constants
    }
}
